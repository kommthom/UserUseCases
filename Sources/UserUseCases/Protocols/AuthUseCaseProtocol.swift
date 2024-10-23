//
//  AuthUseCaseProtocol.swift
//  UserUseCases
//
//  Created by Thomas Benninghaus on 27.12.23.
//

import Vapor
import UserDTOs
import AuthenticationDTOs

public protocol AuthUseCaseProtocol: UseCaseProtocol {
    func login(_ req: Request, loginRequest: LoginRequest) async throws -> LoginResponse
    func register(_ req: Request, registerRequest: UserDTO) async throws -> HTTPStatus
    func refreshAccessToken(_ req: Request, hashedRefreshToken: String) async throws -> AccessTokenResponse
    func getCurrentUser(_ req: Request, payload: Payload) async throws -> UserDTO
    func verifyEmail(_ req: Request, hashedToken: String) async throws -> HTTPStatus
    func resetPassword(_ req: Request, resetPasswordRequest: ResetPasswordRequest) async throws -> HTTPStatus
    func verifyResetPasswordToken(_ req: Request, hashedToken: String) async throws -> HTTPStatus
    func recoverAccount(_ req: Request, contentPassword: String, hashedToken: String) async throws -> HTTPStatus
    func sendEmailVerification(_ req: Request, content: SendEmailVerificationRequest) async throws -> HTTPStatus
}
