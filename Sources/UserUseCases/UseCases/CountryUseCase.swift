//
//  CountryUseCase.swift
//  
//
//  Created by Thomas Benninghaus on 18.05.24.
//

import Vapor
import UserDTOs
import class UserModels.CountryModel

public struct CountryUseCase: CountryUseCaseProtocol {
    public init() {
    }

    public func createCountry(_ req: Request, createCountryRequest: CountryDTO) async throws -> HTTPStatus {
		let country =  CountryModel(with: createCountryRequest)
		try await req.countries
			.create(country)
//		try await req.userLocalization.appendNew(createCountryRequest.name, value: .universal(value: createCountryRequest.localizedName), req: req)
		return .created
    }

    public func getSingleDTO(from model: CountryModel, localization: @escaping @Sendable (String) -> String) -> CountryDTO {
        return CountryDTO(with: model, localization: localization)
    }
    
    public func getManyDTOs(from models: [CountryModel], localization: @escaping @Sendable (String) -> String) -> CountriesDTO {
        return CountriesDTO(many: models, localization: localization)
    }
    
    public func getCountry(_ req: Request, getCountryRequest: UUIDRequest) async throws -> CountryDTO {
		guard let country = try await req.countries
			.find(id: getCountryRequest.id)
		else {
			throw CountryControllerError.missingCountry
		}
		return getSingleDTO(
			from: country,
			localization: {
				$0 // req.userLocalization.localize($0, interpolations: nil, req: req)
			}
		)
    }
    
    public func getCountries(_ req: Request) async throws -> CountriesDTO {
		let countries = try await req.countries
			.all()
		if countries.isEmpty {
			throw CountryControllerError.missingCountry
		}
		return getManyDTOs(
			from: countries,
			localization: {
				$0 // req.userLocalization.localize($0, interpolations: nil, req: req)
			}
		)
    }
    
    public func updateCountry(_ req: Request, updateCountryRequest: CountryDTO) async throws -> HTTPStatus {
        try await req.countries
            .set(CountryModel(with: updateCountryRequest))
		return .noContent
    }

    public func deleteCountry(_ req: Request, deleteCountryRequest: UUIDRequest) async throws -> HTTPStatus {
        try await req.countries
            .delete(id: deleteCountryRequest.id)
      	return .noContent
    }
}
