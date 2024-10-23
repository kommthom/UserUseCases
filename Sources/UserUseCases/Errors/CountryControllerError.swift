//
//  CountryControllerError.swift
//
//
//  Created by Thomas Benninghaus on 18.05.24.
//

import Vapor

enum CountryControllerError: Error {
    case idParameterMissing
    case idParameterInvalid
    case missingCountry
    case invalidForm
    case unableToCreateNewRecord
    case unableToUpdateRecord
    case unableToDeleteRecord
}
