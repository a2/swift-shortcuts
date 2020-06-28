// swift-tools-version:5.3
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
    ],
    targets: [
        .target(
            name: "SwiftShortcuts",
            dependencies: []),
        .testTarget(
            name: "SwiftShortcutsTests",
            dependencies: ["SwiftShortcuts", "SnapshotTesting"],
            exclude: ["__Snapshots__/"]),
    ]
)
