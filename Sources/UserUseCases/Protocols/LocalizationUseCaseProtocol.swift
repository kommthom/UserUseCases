//
//  LocalizationUseCaseProtocol.swift
//  UserUseCases
//
//  Created by Thomas Benninghaus on 14.05.24.
//

import Vapor
import UserDTOs
import class UserModels.LocalizationModel

public protocol LocalizationUseCaseProtocol: UseCaseProtocol {
    func createLocalization(_ req: Request, createLocalizationRequest: LocalizationDTO) async throws -> HTTPStatus
    func getSingleDTO(from model: LocalizationModel) async throws -> LocalizationDTO
    func getManyDTOs(from models: [LocalizationModel]) async throws -> LocalizationsDTO
    func getLocalization(_ req: Request, getLocalizationRequest: UUIDRequest) async throws -> LocalizationDTO
    func getLocalizations(_ req: Request) async throws -> LocalizationsDTO
    func updateLocalization(_ req: Request, updateLocalizationRequest: LocalizationDTO) async throws -> HTTPStatus
    func deleteLocalization(_ req: Request, deleteLocalizationRequest: UUIDRequest) async throws -> HTTPStatus
}
