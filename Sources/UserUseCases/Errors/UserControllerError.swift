//
//  UserControllerError.swift
//  
//
//  Created by Thomas Benninghaus on 06.02.24.
//

import Vapor

enum UserControllerError: Error {
    case idParameterMissing
    case idParameterInvalid
    case missingUser
    case invalidForm
    case unableToCreateNewRecord
    case unableToUpdateRecord
    case unableToDeleteRecord
}
