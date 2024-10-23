//
//  LocaleUseCaseProtocol.swift
//  UserUseCases
//
//  Created by Thomas Benninghaus on 18.05.24.
//

import Vapor
import UserDTOs
import class UserModels.LocaleModel

public protocol LocaleUseCaseProtocol: UseCaseProtocol {
    func createLocale(_ req: Request, createLocaleRequest: LocaleDTO) async throws -> HTTPStatus
    func getSingleDTO(from model: LocaleModel, localization: @escaping @Sendable (String) -> String) -> LocaleDTO
    func getManyDTOs(from models: [LocaleModel], localization: @escaping @Sendable (String) -> String) -> LocalesDTO
    func getLocale(_ req: Request, getLocaleRequest: UUIDRequest) async throws -> LocaleDTO
    func getLocales(_ req: Request) async throws -> LocalesDTO
    func updateLocale(_ req: Request, updateLocaleRequest: LocaleDTO) async throws -> HTTPStatus
    func deleteLocale(_ req: Request, deleteLocaleRequest: UUIDRequest) async throws -> HTTPStatus
}
