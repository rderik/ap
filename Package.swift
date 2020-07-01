// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift
// required to build this package.

import PackageDescription

let package = Package(
    name: "ap",
    dependencies: [
        .package(url: "https://github.com/apple/swift-package-manager.git",
                 from: "0.6.0"),
    ],
    targets: [
        .target(
            name: "ap",
            dependencies: ["SwiftPM"]),
        .testTarget(
            name: "apTests",
            dependencies: ["ap"]),
    ]
)
