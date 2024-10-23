//
//  LocaleUseCase.swift
//  
//
//  Created by Thomas Benninghaus on 18.05.24.
//

import Vapor
import UserDTOs
import class UserModels.LocaleModel

public struct LocaleUseCase: LocaleUseCaseProtocol {
	public init() {
	}
 
	public func createLocale(_ req: Request, createLocaleRequest: LocaleDTO) async throws -> HTTPStatus {
		let locale =  LocaleModel(with: createLocaleRequest)
		try await req.locales
			.create(locale)
//		try await req.userLocalization.appendNew(createLocaleRequest.name, value: .universal(value: createLocaleRequest.localizedName), req: req)
//		try await req.userLocalization.appendNew(createLocaleRequest.description, value: .universal(value: createLocaleRequest.localizedDescription), req: req)
		return .created
	}

	public func getSingleDTO(from model: LocaleModel, localization: @escaping @Sendable (String) -> String) -> LocaleDTO {
		return LocaleDTO(with: model, localization: localization)
	}
	
	public func getManyDTOs(from models: [LocaleModel], localization: @escaping @Sendable (String) -> String) -> LocalesDTO {
		return LocalesDTO(many: models, localization: localization)
	}
	
	public func getLocale(_ req: Request, getLocaleRequest: UUIDRequest) async throws -> LocaleDTO {
		guard let locale = try await req.locales
			.find(id: getLocaleRequest.id)
		else {
			throw LocaleControllerError.missingLocale
		}
		return getSingleDTO(
			from: locale,
			localization: {
				$0 // req.userLocalization.localize($0, interpolations: nil, req: req)
			}
		)
	}
	
	public func getLocales(_ req: Request) async throws -> LocalesDTO {
		let locales = try await req.locales
			.all()
		if locales.isEmpty {
			throw LocaleControllerError.missingLocale
		}
		return getManyDTOs(
			from: locales,
			localization: {
				$0 // req.userLocalization.localize($0, interpolations: nil, req: req)
			}
		)
	}
	
	public func updateLocale(_ req: Request, updateLocaleRequest: LocaleDTO) async throws -> HTTPStatus {
		try await req.locales
			.set(LocaleModel(with: updateLocaleRequest))
		return .noContent
	}

	public func deleteLocale(_ req: Request, deleteLocaleRequest: UUIDRequest) async throws -> HTTPStatus {
		try await req.locales
			.delete(id: deleteLocaleRequest.id)
		return .noContent
	}
}
