//
//  SettingUseCaseProtocol.swift
//  UserUseCases
//
//  Created by Thomas Benninghaus on 31.01.24.
//

import Vapor
import UserDTOs

public protocol SettingUseCaseProtocol: UseCaseProtocol {
    func createSetting(_ req: Request, createSettingRequest: SettingDTO) async throws -> HTTPStatus
    func getSetting(_ req: Request, getSettingRequest: UUIDRequest) async throws -> SettingDTO
    func getSettings(_ req: Request) async throws -> SettingsDTO
    func getSettingsByScope(_ req: Request, getSettingsRequest: GetSettingsRequest) async throws -> SettingsDTO
    func getSidebar(_ req: Request) async throws -> SettingsDTO
    func updateSetting(_ req: Request, updateSettingRequest: SettingDTO) async throws -> HTTPStatus
    func deleteSetting(_ req: Request, deleteSettingRequest: UUIDRequest) async throws -> HTTPStatus
}
