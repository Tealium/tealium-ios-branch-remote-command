// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TealiumBranch",
    products: [
        .library(
            name: "TealiumBranch",
            targets: ["TealiumBranch"]),
    ],
    dependencies: [
        .package(url: "https://github.com/tealium/tealium-swift", from: "2.5.0"),
        .package(url: "https://github.com/BranchMetrics/ios-branch-deep-linking-attribution", from: "1.40.1")
    ],
    targets: [
        .target(
            name: "TealiumBranch",
            dependencies: [],
            path: "Sources"),
        .testTarget(
            name: "TealiumBranchTests",
            dependencies: ["TealiumBranch"]),
    ]
)
