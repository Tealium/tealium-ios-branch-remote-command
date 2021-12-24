// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TealiumBranch",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(
            name: "TealiumBranch",
            targets: ["TealiumBranch"]),
    ],
    dependencies: [
        .package(url: "https://github.com/tealium/tealium-swift", from: "2.6.0"),
        .package(url: "https://github.com/BranchMetrics/ios-branch-sdk-spm", from: "1.40.1")
    ],
    targets: [
        .target(
            name: "TealiumBranch",
            dependencies: [
                .product(name: "TealiumCore", package: "tealium-swift"),
                .product(name: "TealiumRemoteCommands", package: "tealium-swift"),
                .product(name: "Branch", package: "ios-branch-sdk-spm")
            ],
            path: "Sources"),
        .testTarget(
            name: "TealiumBranchTests",
            dependencies: ["TealiumBranch"]),
    ]
)
