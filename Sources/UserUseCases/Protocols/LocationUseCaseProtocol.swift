//
//  LocationUseCaseProtocol.swift
//  UserUseCases
//
//  Created by Thomas Benninghaus on 18.05.24.
//

import Vapor
import UserDTOs
import class UserModels.LocationModel

public protocol LocationUseCaseProtocol: UseCaseProtocol {
    func createLocation(_ req: Request, createLocationRequest: LocationDTO) async throws -> HTTPStatus
    func getSingleDTO(from model: LocationModel, localization: @escaping @Sendable (String) -> String) async throws -> LocationDTO
    func getManyDTOs(from models: [LocationModel], localization: @escaping @Sendable (String) -> String) async throws -> LocationsDTO
    func getLocation(_ req: Request, getLocationRequest: UUIDRequest) async throws -> LocationDTO
    func getLocations(_ req: Request) async throws -> LocationsDTO
    func updateLocation(_ req: Request, updateLocationRequest: LocationDTO) async throws -> HTTPStatus
    func deleteLocation(_ req: Request, deleteLocationRequest: UUIDRequest) async throws -> HTTPStatus
}
