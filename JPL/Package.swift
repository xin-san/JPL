// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JPL",
    platforms: [
        .iOS(.v14),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "JPL",
            targets: ["JPL"]),
    ],
    dependencies: [
        .package(path: "VocabularyTypes")
    ],
    targets: [
        .target(
            name: "JPL",
            dependencies: ["VocabularyTypes"]),
        .testTarget(
            name: "JPLTests",
            dependencies: ["JPL"]),
    ]
) 