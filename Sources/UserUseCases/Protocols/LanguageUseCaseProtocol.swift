//
//  LanguageUseCaseProtocol.swift
//  UserUseCases
//
//  Created by Thomas Benninghaus on 18.05.24.
//

import Vapor
import UserDTOs
import class UserModels.LanguageModel

public protocol LanguageUseCaseProtocol: UseCaseProtocol {
    func createLanguage(_ req: Request, createLanguageRequest: LanguageDTO) async throws -> HTTPStatus
    func getSingleDTO(from model: LanguageModel, localization: @escaping @Sendable (String) -> String) -> LanguageDTO
    func getManyDTOs(from models: [LanguageModel], localization: @escaping @Sendable (String) -> String) -> LanguagesDTO
    func getLanguage(_ req: Request, getLanguageRequest: UUIDRequest) async throws -> LanguageDTO
    func getLanguages(_ req: Request) async throws -> LanguagesDTO
    func updateLanguage(_ req: Request, updateLanguageRequest: LanguageDTO) async throws -> HTTPStatus
    func deleteLanguage(_ req: Request, deleteLanguageRequest: UUIDRequest) async throws -> HTTPStatus
}
