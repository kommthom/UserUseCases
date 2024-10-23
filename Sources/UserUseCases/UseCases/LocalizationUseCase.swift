//
//  LocalizationUseCase.swift
//
//
//  Created by Thomas Benninghaus on 14.05.24.
//

import Vapor
import UserDTOs
import class UserModels.LocalizationModel

public struct LocalizationUseCase: LocalizationUseCaseProtocol {
	public init() {
	}
 
	public func createLocalization(_ req: Request, createLocalizationRequest: LocalizationDTO) async throws -> HTTPStatus {
		let localization =  LocalizationModel(with: createLocalizationRequest)
		try await req.localizations
			.create(localization)
		return .created
	}

	public func getSingleDTO(from model: LocalizationModel) -> LocalizationDTO {
		return LocalizationDTO(with: model)
	}
	
	public func getManyDTOs(from models: [LocalizationModel]) -> LocalizationsDTO {
		return LocalizationsDTO(many: models)
	}
	
	public func getLocalization(_ req: Request, getLocalizationRequest: UUIDRequest) async throws -> LocalizationDTO {
		guard let localization = try await req.localizations
			.find(id: getLocalizationRequest.id)
		else {
			throw LocalizationControllerError.missingLocalization
		}
		return getSingleDTO(
			from: localization
		)
	}
	
	public func getLocalizations(_ req: Request) async throws -> LocalizationsDTO {
		let localizations = try await req.localizations
			.all()
		if localizations.isEmpty {
			throw LocalizationControllerError.missingLocalization
		}
		return getManyDTOs(
			from: localizations
		)
	}
	
	public func updateLocalization(_ req: Request, updateLocalizationRequest: LocalizationDTO) async throws -> HTTPStatus {
		try await req.localizations
			.set(LocalizationModel(with: updateLocalizationRequest))
		return .noContent
	}

	public func deleteLocalization(_ req: Request, deleteLocalizationRequest: UUIDRequest) async throws -> HTTPStatus {
		try await req.localizations
			.delete(id: deleteLocalizationRequest.id, force: false)
		return .noContent
	}
}

