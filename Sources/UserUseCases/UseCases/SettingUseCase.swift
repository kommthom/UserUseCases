//
//  SettingUseCase.swift
//  
//
//  Created by Thomas Benninghaus on 01.02.24.
//

import Vapor
import UserDTOs
import class UserModels.SettingModel
import struct UserModels.AuthenticatedUser

/// Use cases for Users
public struct SettingUseCase: SettingUseCaseProtocol {
    
    /// Default initializer.
    public init() {
        
    }
    
    private func getAuthenticatedUser(_ req: Request) throws -> AuthenticatedUser? {
        if let authenticatedUser = req.auth.get(AuthenticatedUser.self) {
            return authenticatedUser
        } else {
            throw AuthenticationError.userNotFound
        }
    }
    
    public func createSetting(_ req: Request, createSettingRequest: SettingDTO) async throws -> HTTPStatus {
		let authenticatedUser = try getAuthenticatedUser(req)
		let setting = SettingModel(with: createSettingRequest, for: authenticatedUser!.id)
		try await req.settings
			.create(setting)
	//		try await req.userLocalization.appendNew(createSettingRequest.name, value: .universal(value: createSettingRequest.localizedName), req: req)
		return .created
    }
	
	public func getSingleDTO(from model: SettingModel, localization: @escaping @Sendable (String) -> String) -> SettingDTO {
		return SettingDTO(with: model, localization: localization)
	}
	
	public func getManyDTOs(from models: [SettingModel], localization: @escaping @Sendable (String) -> String) -> SettingsDTO {
		return SettingsDTO(many: models, localization: localization)
	}

    public func getSetting(_ req: Request, getSettingRequest: UUIDRequest) async throws -> SettingDTO {
		let authenticatedUser = try getAuthenticatedUser(req)
		guard let setting = try await req.settings
			.find(id: getSettingRequest.id)
		else {
			throw SettingControllerError.missingSetting
		}
		return getSingleDTO(
			from: setting,
			localization: {
				$0 // req.userLocalization.localize($0, interpolations: nil, req: req)
			}
		)
    }
    
    public func getSettings(_ req: Request) async throws -> SettingsDTO {
		let authenticatedUser = try getAuthenticatedUser(req)
		let settings = try await req.settings
			.all(userId: authenticatedUser?.id)
		if settings.isEmpty {
			throw SettingControllerError.missingSetting
		}
		return getManyDTOs(
			from: settings,
			localization: {
				$0 // req.userLocalization.localize($0, interpolations: nil, req: req)
			}
		)
    }
    
    public func getSettingsByScope(_ req: Request, getSettingsRequest: GetSettingsRequest) async throws -> SettingsDTO {
		let authenticatedUser = try getAuthenticatedUser(req)
		let settings = try await req.settings
			.all(userId: authenticatedUser?.id, type: getSettingsRequest.scope)
		if settings.isEmpty {
			throw SettingControllerError.missingSetting
		}
		return getManyDTOs(
			from: settings,
			localization: {
				$0 // req.userLocalization.localize($0, interpolations: nil, req: req)
			}
		)
    }
    
    public func getSidebar(_ req: Request) async throws -> SettingsDTO {
		let authenticatedUser = try getAuthenticatedUser(req)
		let settings = try await req.settings
			.sidebar(userId: authenticatedUser?.id)
		if settings.isEmpty {
			throw SettingControllerError.missingSetting
		}
		return getManyDTOs(
			from: settings,
			localization: {
				$0 // req.userLocalization.localize($0, interpolations: nil, req: req)
			}
		)
    }
    
    public func updateSetting(_ req: Request, updateSettingRequest: SettingDTO) async throws -> HTTPStatus {
		let setting = SettingModel(with: updateSettingRequest, for: try getAuthenticatedUser(req)!.id)
		try await req.settings
			.set(setting)
		return .noContent
    }

    public func deleteSetting(_ req: Request, deleteSettingRequest: UUIDRequest) async throws -> HTTPStatus {
		try await req.settings
			.delete(id: deleteSettingRequest.id, force: false)
		return .noContent
    }
}
