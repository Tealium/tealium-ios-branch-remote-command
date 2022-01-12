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
        .package(name: "TealiumSwift", url: "https://github.com/tealium/tealium-swift", .upToNextMajor(from: "2.6.0")),
        .package(name: "Branch", url: "https://github.com/BranchMetrics/ios-branch-sdk-spm", .upToNextMajor(from: "1.40.1"))
    ],
    targets: [
        .target(
            name: "TealiumBranch",
            dependencies: [
                .product(name: "TealiumCore", package: "TealiumSwift"),
                .product(name: "TealiumRemoteCommands", package: "TealiumSwift"),
                .product(name: "Branch", package: "Branch")
            ],
            path: "Sources"),
        .testTarget(
            name: "TealiumBranchTests",
            dependencies: ["TealiumBranch"]),
    ]
)
