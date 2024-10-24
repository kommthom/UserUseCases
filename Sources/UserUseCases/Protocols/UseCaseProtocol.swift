//
//  UseCaseProtocol.swift
//  UserUseCases
//
//  Created by Thomas Benninghaus on 21.12.23.
//

/// Use case in controller.
///
/// UseCase is the domain layer entrance.
/// Accept orders from Presentation layer. Accepting and handing over the processing to the appropriate Repository is the role of the UseCase. Do not depend on the Infrastructure layer. This is because the dependence on external libraries cannot be cut out well.
/// UseCase shouldn't care about the implementation. Just be there to throw work to the Repository. Imagine a consulting person who correctly understands who to work with. It's impossible for him to work, except for very simple tasks.
/// ### Repletion
/// This is the protocol that lets swift-doc generate documentation. It hasn't functional meaning.
public protocol UseCaseProtocol {}
