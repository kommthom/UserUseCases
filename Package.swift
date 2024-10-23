// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UserUseCases",
	platforms: [
		.macOS(.v15)
	],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "UserUseCases",
            targets: ["UserUseCases"]),
    ],
	dependencies: [
		.package(url: "https://github.com/vapor/vapor", from: "4.106.0"),
		.package(name: "UserModels", path: "../UserModels"),
		.package(name: "UserEmails", path: "../UserEmails"),
	],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "UserUseCases",
			dependencies: [
				.product(
					name: "Vapor",
					package: "Vapor"
				),
				.product(
					name: "UserModels",
					package: "UserModels"
				),
				.product(
					name: "UserEmails",
					package: "UserEmails"
				)
			]
		),
        .testTarget(
            name: "UserUseCasesTests",
            dependencies: ["UserUseCases"]
        ),
    ]
)
