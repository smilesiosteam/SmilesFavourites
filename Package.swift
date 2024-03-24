// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SmilesFavourites",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SmilesFavourites",
            targets: ["SmilesFavourites"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/smilesiosteam/SmilesFontsManager.git", branch: "main"),
        .package(url: "https://github.com/smilesiosteam/SmilesUtilities.git", branch: "main"),
        .package(url: "https://github.com/smilesiosteam/SmilesBaseMainRequest.git", branch: "main"),
        .package(url: "https://github.com/smilesiosteam/NetworkingLayer.git", branch: "main"),
        .package(url: "https://github.com/smilesiosteam/SmilesOffers.git", branch: "main"),
        .package(url: "https://github.com/smilesiosteam/SmilesSharedServices.git", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SmilesFavourites",
            dependencies: [
                .product(name: "SmilesFontsManager", package: "SmilesFontsManager"),
                .product(name: "SmilesUtilities", package: "SmilesUtilities"),
                .product(name: "SmilesBaseMainRequestManager", package: "SmilesBaseMainRequest"),
                .product(name: "NetworkingLayer", package: "NetworkingLayer"),
                .product(name: "SmilesOffers", package: "SmilesOffers"),
                .product(name: "SmilesSharedServices", package: "SmilesSharedServices")
            ],
            resources: [
                .process("Resources")
            ]),
        .testTarget(
            name: "SmilesFavouritesTests",
            dependencies: ["SmilesFavourites"]),
    ]
)
