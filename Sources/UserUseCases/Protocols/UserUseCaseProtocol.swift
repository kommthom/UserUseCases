//
//  UserUseCaseProtocol.swift
//  UserUseCases
//
//  Created by Thomas Benninghaus on 27.12.23.
//

import Vapor
import UserDTOs
import AuthenticationDTOs
import class UserModels.UserModel

public protocol UserUseCaseProtocol: UseCaseProtocol {
    func createUser(_ req: Request, createUserRequest: UserDTO) async throws -> HTTPStatus
	func getSingleDTO(from model: UserModel, localization: @escaping @Sendable (String) -> String) -> UserDTO
	func getManyDTOs(from models: [UserModel], localization: @escaping @Sendable (String) -> String) -> UsersDTO
    func getUser(_ req: Request, getUserRequest: UUIDRequest) async throws -> UserDTO
    func getUsers(_ req: Request) async throws -> UsersDTO
    func updateUser(_ req: Request, payload: Payload) async throws -> HTTPStatus
    func deleteUser(_ req: Request, deleteUserRequest: UUIDRequest) async throws -> HTTPStatus
}
