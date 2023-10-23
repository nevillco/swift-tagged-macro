// swift-tools-version: 5.9

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "swift-tagged-macro",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "TaggedMacro",
            targets: ["TaggedMacro"]
        ),
        .executable(
            name: "TaggedMacroExample",
            targets: ["TaggedMacroExample"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-tagged",
            from: "0.6.0"
        ),
        .package(
            url: "https://github.com/apple/swift-syntax.git",
            "508.0.0"..<"510.0.0"
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-macro-testing",
            from: "0.2.1"
        ),
    ],
    targets: [
        // Actual macro implementation that performs the compile-time codegen.
        .macro(
            name: "TaggedMacroMacro",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),
        // Library that exposes a macro as part of its API,
        // which can be used by external clients.
        .target(
            name: "TaggedMacro",
            dependencies: ["TaggedMacroMacro"]
        ),
        // An example client to demonstrate usage.
        .executableTarget(
            name: "TaggedMacroExample",
            dependencies: [
                "TaggedMacro",
                .product(name: "Tagged", package: "swift-tagged"),
            ]
        ),
        // A test target used to develop the macro implementation.
        .testTarget(
            name: "TaggedMacroTests",
            dependencies: [
                "TaggedMacroMacro",
                .product(
                    name: "SwiftSyntaxMacrosTestSupport",
                    package: "swift-syntax"
                ),
                .product(
                    name: "MacroTesting",
                    package: "swift-macro-testing"
                )
            ]
        ),
    ]
)
