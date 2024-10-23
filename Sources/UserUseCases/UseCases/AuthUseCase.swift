//
//  AuthUseCase.swift
//  UserUseCases
//
//  Created by Thomas Benninghaus on 21.12.23.
//

import Vapor
import AuthenticationDTOs
import UserDTOs
import UserModels
import UserEmails

/// Use cases for Authentication
public struct AuthUseCase: AuthUseCaseProtocol {
    private let logger = Logger(label: "reminders.backend.authusecase")

    public init() { }
    
    public func login(_ req: Request, loginRequest: LoginRequest) async throws -> LoginResponse {
		guard let user = try await req.users
			.find(email: loginRequest.email)
		else {
			throw AuthenticationError.invalidEmailOrPassword
		}
		guard user.isEmailVerified else {
			throw AuthenticationError.emailIsNotVerified
		}
		logger.info("login user:\(user.email)|\(user.passwordHash)")
		guard try req.password
			.verify(
				loginRequest.password,
				created: user.passwordHash
			)
		else {
			throw AuthenticationError.invalidEmailOrPassword
		}
		logger.info("Delete token for user: \(user.email)")
		try await req.refreshTokens.delete(for: user.requireID())
		let token = req.random
			.generate(bits: 256)
		logger.info("Create token for user: \(user.email): \(token)")
		let refreshToken = try RefreshToken(token: SHA256.hash(token), userID: user.requireID())
		logger.info("RefreshToken for user: \(user.email) token: \(token) refreshToken: \(refreshToken.token)")
		try await req.refreshTokens
			.create(refreshToken)
		logger.info("Return user: \(user.email) token: \(token)")
//		let localization = {
//			req.userLocalization
//					  .localize(
//						  $0,
//						  interpolations: nil,
//						  req: req
//					  )
//			  }
		let accessToken = try await req.jwt
			.sign(
				   Payload(
					   with: user,
					   localization: { $0 } // localization
				   )
			   )
		return LoginResponse(
			user: UserDTO(
				with: user,
				localization: { $0 } // localization
			),
			accessToken: accessToken,
			refreshToken: token
		)
	}

    public func register(_ req: Request, registerRequest: UserDTO) async throws -> HTTPStatus {
		guard registerRequest.password == registerRequest.confirmPassword else {
			throw AuthenticationError.passwordsDontMatch
		}
		let existing = try await req.users.find(email: registerRequest.email)
		guard existing == nil else {
			throw AuthenticationError.emailAlreadyExists
		}
		let pw = try await req.password
							  .async
							  .hash(registerRequest.password)
		let user =  try UserModel(with: registerRequest, hash: pw)
		try await req.users.create(user)
		try await req.emailVerifier
			.verify(for: user)
		return .created
    }

    public func refreshAccessToken(_ req: Request, hashedRefreshToken: String) async throws -> AccessTokenResponse {
		guard let refreshToken = try await req.refreshTokens.find(token: hashedRefreshToken) else {
			throw AuthenticationError.refreshTokenOrUserNotFound
		}
		try await req.refreshTokens.delete(refreshToken)
		guard refreshToken.expiresAt > Date() else {
			throw AuthenticationError.refreshTokenHasExpired
		}
		guard let user = try await req.users.find(id: refreshToken.$user.id) else {
			throw AuthenticationError.refreshTokenOrUserNotFound
		}
		let token = req.random.generate(bits: 256)
		
		let newToken = try RefreshToken(
			token: SHA256.hash(token),
			userID: user.requireID()
		)
		let payload = try Payload(
			with: user,
			localization: { $0 } //req.userLocalization.localize($0, interpolations: nil, req: req)
		)
		let accessToken = try await req.jwt.sign(payload)
		try await req.refreshTokens
			.create(newToken)
		return AccessTokenResponse(refreshToken: token,
								   accessToken: accessToken)
    }
    
    public func getCurrentUser(_ req: Request, payload: Payload) async throws -> UserDTO {
		//let payload = try req.auth.require(Payload.self)
		guard let currentUser = try await  req.users
			.find(id: payload.userID.rawValue)
		else {
			throw AuthenticationError.userNotFound
		}
		return UserDTO(
			with: currentUser,
			localization: {
				$0 // req.userLocalization.localize($0, interpolations: nil, req: req)
			}
		)
    }
    
    public func verifyEmail(_ req: Request, hashedToken: String) async throws -> HTTPStatus {
		guard let token = try await req.emailTokens
			.find(token: hashedToken)
		else {
			throw AuthenticationError.emailTokenNotFound
		}
		try await req.emailTokens.delete(token)
		guard token.expiresAt > Date() else {
			throw AuthenticationError.emailTokenHasExpired
		}
		try await req.users.set(\.$isEmailVerified,
								 to: true,
								 for: token.$user.id)
		return  .ok
    }
    
    public func resetPassword(_ req: Request, resetPasswordRequest: ResetPasswordRequest) async throws -> HTTPStatus {
		guard let user = try await req.users
			.find(email: resetPasswordRequest.email)
		else {
			 return .noContent
		}
		try await req.passwordResetter
			.reset(for: user)
		return .noContent
    }
    
    public func verifyResetPasswordToken(_ req: Request, hashedToken: String) async throws -> HTTPStatus {
		guard let token = try await req.passwordTokens
			.find(token: hashedToken)
		else {
			throw AuthenticationError.invalidPasswordToken
		}
		guard token.expiresAt > Date() else {
			try await req.passwordTokens.delete(token)
			throw AuthenticationError.passwordTokenHasExpired
		}
		return .noContent
    }
    
    public func recoverAccount(_ req: Request, contentPassword: String, hashedToken: String) async throws -> HTTPStatus {
		guard let passwordToken = try await req.passwordTokens
			.find(token: hashedToken)
		else {
			throw AuthenticationError.invalidPasswordToken
		}
		guard passwordToken.expiresAt > Date() else {
			try await req.passwordTokens
				.delete(passwordToken)
			throw AuthenticationError.passwordTokenHasExpired
		}
		let digest = try await req.password
			.async
			.hash(contentPassword)
		try await req.users
			.set(
				\.$passwordHash,
				to: digest,
				for: passwordToken.$user.id
			)
		try await req.passwordTokens
			.delete(for: passwordToken.$user.id)
		return  .noContent
    }
    
    public func sendEmailVerification(_ req: Request, content: SendEmailVerificationRequest) async throws -> HTTPStatus {
		guard let user = try await req.users
			.find(email: content.email)
		else {
			return .noContent
		}
		guard !user
			.isEmailVerified
		else {
			return .noContent
		}
		try await req.emailVerifier
			.verify(for: user)
		return .noContent
    }
}
