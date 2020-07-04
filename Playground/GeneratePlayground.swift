#!/usr/bin/swift
import Foundation

extension FileManager {
    func directoryExists(at url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        return fileExists(atPath: url.path, isDirectory: &isDirectory) && isDirectory.boolValue
    }
}

let fileManager = FileManager()
let isDebuggable: Bool = UserDefaults.standard.bool(forKey: "debug") // use -debug

// Get the Playgrounds directory
let playgroundsDirectory = URL(fileURLWithPath: fileManager.currentDirectoryPath)
    .appendingPathComponent(CommandLine.arguments.first!)
    .deletingLastPathComponent()

// Read the version from the arguments
let version = UserDefaults.standard.string(forKey: "version") ?? ""
if version.isEmpty {
    print("Specify version using -version argument")
    exit(EXIT_FAILURE)
}

let templateURL = playgroundsDirectory.appendingPathComponent("SwiftShortcutsTemplate.playgroundbook")
let playgroundURL = playgroundsDirectory.appendingPathComponent("SwiftShortcuts.playgroundbook")

// Remove the old output if it was there
if fileManager.directoryExists(at: playgroundURL) {
    try fileManager.removeItem(at: playgroundURL)
}

// Move the template to the output
try fileManager.copyItem(at: templateURL, to: playgroundURL)

let manifestURL = playgroundURL
    .appendingPathComponent("Contents", isDirectory: true)
    .appendingPathComponent("Manifest.plist", isDirectory: false)

// Write the version number to the manifest
let manifestData = try Data(contentsOf: manifestURL)
var manifest = try PropertyListSerialization.propertyList(from: manifestData, format: nil) as! [String: Any]
manifest["ContentVersion"] = version
try PropertyListSerialization.data(fromPropertyList: manifest, format: .xml, options: .zero).write(to: manifestURL)

// Work out where we're moving source code from and to
let sourceDirectory = playgroundsDirectory.appendingPathComponent("../Sources/SwiftShortcuts")
let outputDirectory = playgroundURL
    .appendingPathComponent("Contents", isDirectory: true)
    .appendingPathComponent(isDebuggable ? "UserModules": "Modules", isDirectory: true)
    .appendingPathComponent("SwiftShortcuts.playgroundmodule", isDirectory: true)
    .appendingPathComponent("Sources", isDirectory: true)

// Create the output directory if it does not exist yet
if !fileManager.directoryExists(at: outputDirectory) {
    try fileManager.createDirectory(at: outputDirectory, withIntermediateDirectories: true, attributes: nil)
}

// Create an enumerator for the source files
let resourceKeys = Set<URLResourceKey>([.typeIdentifierKey])
let enumerator = fileManager.enumerator(
    at: sourceDirectory,
    includingPropertiesForKeys: Array(resourceKeys),
    options: .skipsHiddenFiles
)!

// Move each .swift file into the root Sources directory
// This is because the Playgrounds app doesn't support nested directories in UserModules - FB7606658
for case let fileURL as URL in enumerator {
    let resourceValues = try fileURL.resourceValues(forKeys: resourceKeys)
    guard resourceValues.typeIdentifier == "public.swift-source" else { continue }

    try fileManager.copyItem(
        at: fileURL,
        to: outputDirectory.appendingPathComponent(fileURL.lastPathComponent, isDirectory: false)
    )
}

print("Generated playground at '\(playgroundURL.path)'")
