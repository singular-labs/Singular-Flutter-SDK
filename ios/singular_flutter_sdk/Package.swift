// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "singular_flutter_sdk",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "singular-flutter-sdk", targets: ["singular_flutter_sdk"])
    ],
    dependencies: [
        .package(url: "https://github.com/singular-labs/Singular-iOS-SDK.git", exact: "12.13.0")
    ],
    targets: [
        .target(
            name: "singular_flutter_sdk",
            dependencies: [
                .product(name: "Singular", package: "Singular-iOS-SDK")
            ],
            cSettings: [
                .headerSearchPath("include/singular_flutter_sdk")
            ]
        )
    ]
)
