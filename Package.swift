// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "SwiftShortcuts",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "SwiftShortcuts",
            targets: ["SwiftShortcuts"]),
    ],
    dependencies: [
        .package(name: "SnapshotTesting", url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.8.1"),
        .package(url: "https://github.com/nerdsupremacist/AssociatedTypeRequirementsKit.git", from: "0.2.0"),
    ],
    targets: [
        .target(
            name: "SwiftShortcuts",
            dependencies: ["AssociatedTypeRequirementsKit"]),
        .testTarget(
            name: "SwiftShortcutsTests",
            dependencies: ["SwiftShortcuts", "SnapshotTesting"],
            exclude: ["__Snapshots__/"]),
    ]
)
