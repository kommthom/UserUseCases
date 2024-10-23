//
//  LocationUseCase.swift
//  
//
//  Created by Thomas Benninghaus on 18.05.24.
//

import Vapor
import UserDTOs
import class UserModels.LocationModel

public struct LocationUseCase: LocationUseCaseProtocol {
	public init() {
	}
 
	public func createLocation(_ req: Request, createLocationRequest: LocationDTO) async throws -> HTTPStatus {
		let location =  LocationModel(with: createLocationRequest)
		try await req.locations
			.create(location)
	//		try await req.userLocalization.appendNew(createLocationRequest.name, value: .universal(value: createLocationRequest.localizedName), req: req)
		return .created
	}

	public func getSingleDTO(from model: LocationModel, localization: @escaping @Sendable (String) -> String) -> LocationDTO {
		return LocationDTO(with: model, localization: localization)
	}
	
	public func getManyDTOs(from models: [LocationModel], localization: @escaping @Sendable (String) -> String) -> LocationsDTO {
		return LocationsDTO(many: models, localization: localization)
	}
	
	public func getLocation(_ req: Request, getLocationRequest: UUIDRequest) async throws -> LocationDTO {
		guard let location = try await req.locations
			.find(id: getLocationRequest.id)
		else {
			throw LocationControllerError.missingLocation
		}
		return getSingleDTO(
			from: location,
			localization: {
				$0 // req.userLocalization.localize($0, interpolations: nil, req: req)
			}
		)
	}
	
	public func getLocations(_ req: Request) async throws -> LocationsDTO {
		let locations = try await req.locations
			.all()
		if locations.isEmpty {
			throw LocationControllerError.missingLocation
		}
		return getManyDTOs(
			from: locations,
			localization: {
				$0 // req.userLocalization.localize($0, interpolations: nil, req: req)
			}
		)
	}
	
	public func updateLocation(_ req: Request, updateLocationRequest: LocationDTO) async throws -> HTTPStatus {
		try await req.locations
			.set(LocationModel(with: updateLocationRequest))
		return .noContent
	}

	public func deleteLocation(_ req: Request, deleteLocationRequest: UUIDRequest) async throws -> HTTPStatus {
		try await req.locations
			.delete(id: deleteLocationRequest.id)
		return .noContent
	}
}
