//
//  LanguageUseCase.swift
//  
//
//  Created by Thomas Benninghaus on 18.05.24.
//

import Vapor
import UserDTOs
import class UserModels.LanguageModel

public struct LanguageUseCase: LanguageUseCaseProtocol {
    public init() {
    }
 
    public func createLanguage(_ req: Request, createLanguageRequest: LanguageDTO) async throws -> HTTPStatus {
		let language =  LanguageModel(with: createLanguageRequest)
		try await req.languages
			.create(language)
	//		try await req.userLocalization.appendNew(createLanguageRequest.name, value: .universal(value: createLanguageRequest.localizedName), req: req)
		return .created
    }

    public func getSingleDTO(from model: LanguageModel, localization: @escaping @Sendable (String) -> String) -> LanguageDTO {
        return LanguageDTO(with: model, localization: localization)
    }
    
    public func getManyDTOs(from models: [LanguageModel], localization: @escaping @Sendable (String) -> String) -> LanguagesDTO {
        return LanguagesDTO(many: models, localization: localization)
    }
    
    public func getLanguage(_ req: Request, getLanguageRequest: UUIDRequest) async throws -> LanguageDTO {
		guard let language = try await req.languages
			.find(id: getLanguageRequest.id)
		else {
			throw LanguageControllerError.missingLanguage
		}
		return getSingleDTO(
			from: language,
			localization: {
				$0 // req.userLocalization.localize($0, interpolations: nil, req: req)
			}
		)
    }
    
    public func getLanguages(_ req: Request) async throws -> LanguagesDTO {
		let languages = try await req.languages
			.all()
		if languages.isEmpty {
			throw LanguageControllerError.missingLanguage
		}
		return getManyDTOs(
			from: languages,
			localization: {
				$0 // req.userLocalization.localize($0, interpolations: nil, req: req)
			}
		)
    }
    
    public func updateLanguage(_ req: Request, updateLanguageRequest: LanguageDTO) async throws -> HTTPStatus {
		try await req.languages
			.set(LanguageModel(with: updateLanguageRequest))
		return .noContent
    }

    public func deleteLanguage(_ req: Request, deleteLanguageRequest: UUIDRequest) async throws -> HTTPStatus {
		try await req.languages
			.delete(id: deleteLanguageRequest.id)
		return .noContent
    }
}
