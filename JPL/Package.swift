// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JPL",
    defaultLocalization: "zh",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "JPL",
            type: .dynamic,
            targets: ["JPL"]),
    ],
    dependencies: [
        .package(path: "VocabularyTypes"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "10.0.0")),
        .package(url: "https://github.com/google/GoogleSignIn-iOS.git", .upToNextMajor(from: "7.0.0")),
        .package(url: "https://github.com/realm/realm-swift.git", .upToNextMajor(from: "10.42.3")),
        .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "7.0.0")),
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", .upToNextMajor(from: "5.0.0"))
    ],
    targets: [
        .target(
            name: "JPL",
            dependencies: [
                "VocabularyTypes",
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseStorage", package: "firebase-ios-sdk"),
                .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS"),
                .product(name: "GoogleSignInSwift", package: "GoogleSignIn-iOS"),
                .product(name: "RealmSwift", package: "realm-swift"),
                .product(name: "Kingfisher", package: "Kingfisher"),
                .product(name: "SwiftyJSON", package: "SwiftyJSON")
            ],
            path: "JPL",
            exclude: ["Info.plist", "GoogleService-Info.plist"],
            swiftSettings: [
                .define("DISABLE_PLIST_GENERATION")
            ]
        )
    ]
) 