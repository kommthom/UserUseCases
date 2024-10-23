//
//  UserUseCase.swift
//
//
//  Created by Thomas Benninghaus on 27.12.23.
//

import Vapor
import UserDTOs
import AuthenticationDTOs
import class UserModels.UserModel

public struct UserUseCase: UserUseCaseProtocol {
    public init() {}

	public func createUser(_ req: Request, createUserRequest: UserDTO) async throws -> HTTPStatus {
		guard createUserRequest.password == createUserRequest.confirmPassword else {
			throw AuthenticationError.passwordsDontMatch
		}
		let existing = try await req.users.find(email: createUserRequest.email)
		guard existing == nil else {
			throw AuthenticationError.emailAlreadyExists
		}
		let pw = try await req.password
							  .async
							  .hash(createUserRequest.password)
		let user =  try UserModel(with: createUserRequest, hash: pw)
		try await req.users.create(user)
		try await req.emailVerifier
			.verify(for: user)
		return .created
	}

	public func getSingleDTO(from model: UserModel, localization: @escaping @Sendable (String) -> String) -> UserDTO {
		return UserDTO(with: model, localization: localization)
	}
	
	public func getManyDTOs(from models: [UserModel], localization: @escaping @Sendable (String) -> String) -> UsersDTO {
		return UsersDTO(many: models, localization: localization)
	}
	
	public func getUser(_ req: Request, getUserRequest: UUIDRequest) async throws -> UserDTO {
		guard let user = try await req.users
			.find(id: getUserRequest.id)
		else {
			throw UserControllerError.missingUser
		}
		return getSingleDTO(
			from: user,
			localization: {
				$0 // req.userLocalization.localize($0, interpolations: nil, req: req)
			}
		)
	}
	
	public func getUsers(_ req: Request) async throws -> UsersDTO {
		let users = try await req.users
			.all()
		if users.isEmpty {
			throw UserControllerError.missingUser
		}
		return getManyDTOs(
			from: users,
			localization: {
				$0 // req.userLocalization.localize($0, interpolations: nil, req: req)
			}
		)
	}
	
	public func updateUser(_ req: Request, payload: AuthenticationDTOs.Payload) async throws -> HTTPStatus {
		try await req.users
			.set(UserModel(with: payload))
		return .noContent
	}

	public func deleteUser(_ req: Request, deleteUserRequest: UUIDRequest) async throws -> HTTPStatus {
		try await req.users
			.delete(id: deleteUserRequest.id, force: false)
		return .noContent
	}
}
