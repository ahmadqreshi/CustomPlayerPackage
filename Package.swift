// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LaPlayer",
    platforms: [
            .iOS(.v13)
        ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "LaPlayer",
            targets: ["LaPlayer"]),
    ],
    dependencies: [
        .package(url: "https://github.com/brightcove/brightcove-player-sdk-ios.git", from: "6.11.2"),
        .package(url: "https://github.com/airbnb/lottie-spm.git", from: "4.1.2"),
        .package(url: "https://github.com/learnapp-co/learnapp-ios-resources.git", branch: "main")
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "LaPlayer",
            dependencies: [
                .product(name: "BrightcovePlayerSDK", package: "brightcove-player-sdk-ios"),
                .product(name: "Lottie", package: "lottie-spm"),
                .product(name: "LAResources", package: "learnapp-ios-resources")
            ],
            path: "Sources"),
        .testTarget(
            name: "LaPlayerTests",
            dependencies: ["LaPlayer"]),
    ]
)
