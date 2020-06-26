// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "SwiftShortcuts",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "SwiftShortcuts",
            targets: ["SwiftShortcuts"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
    ],
    targets: [
        .target(
            name: "SwiftShortcuts",
            dependencies: []),
        .testTarget(
            name: "SwiftShortcutsTests",
            dependencies: ["SwiftShortcuts"]),
    ]
)
