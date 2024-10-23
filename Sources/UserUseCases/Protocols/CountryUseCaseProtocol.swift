//
//  CountryUseCaseProtocol.swift
//  UserUseCases
//
//  Created by Thomas Benninghaus on 18.05.24.
//

import Vapor
import UserDTOs
import class UserModels.CountryModel

public protocol CountryUseCaseProtocol: UseCaseProtocol {
    func createCountry(_ req: Request, createCountryRequest: CountryDTO) async throws -> HTTPStatus
    func getSingleDTO(from model: CountryModel, localization: @escaping @Sendable (String) -> String) async throws -> CountryDTO
    func getManyDTOs(from models: [CountryModel], localization: @escaping @Sendable (String) -> String) async throws -> CountriesDTO
    func getCountry(_ req: Request, getCountryRequest: UUIDRequest) async throws -> CountryDTO
    func getCountries(_ req: Request) async throws -> CountriesDTO
    func updateCountry(_ req: Request, updateCountryRequest: CountryDTO) async throws -> HTTPStatus
    func deleteCountry(_ req: Request, deleteCountryRequest: UUIDRequest) async throws -> HTTPStatus
}
