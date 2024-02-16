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
        .target(
            name: "SwiftUIError",
            plugins: []
        ),
        .target(name: "SwiftUIErrorExample", dependencies: ["SwiftUIError"]),
        .testTarget(
            name: "SwiftUIErrorTests",
            dependencies: ["SwiftUIError"]),
    ]
)
