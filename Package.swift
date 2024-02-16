// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swiftui-error",
    platforms: [
        .iOS(.v13),
        .macOS("10.15.4"),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    products: [
        .library(
            name: "SwiftUIError",
            targets: ["SwiftUIError"]
        ),
        .library(name: "SwiftUIErrorExample", targets: ["SwiftUIErrorExample"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.1.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftUIError",
            plugins: []
        ),
        .testTarget(
            name: "SwiftUIErrorTests",
            dependencies: ["SwiftUIError"]),
    ]
)
