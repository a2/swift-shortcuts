import Foundation
import SwiftShell

enum BuildError: Error {
	case pathNotValid
}

extension Shortcut {
    var payload: ShortcutPayload {
        let decomposed = body.decompose()
        let encodableActionComponents = decomposed.map { actionStep in actionStep.encodable() }
        return ShortcutPayload(actions: encodableActionComponents)
    }

    /// Serializes the body of the Shortcut to a file format suitable for opening in the Shortcuts app.
    /// - Throws: An error of type `EncodingError`, if one is thrown during the encoding process.
    /// - Returns: The binary data representing this Shortcut.
	@available(*, deprecated, message: "Please use buildAndSave(toPath:sign:) instead")
    public func build() throws -> Data {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .binary
        return try encoder.encode(payload)
    }
	
	/// Build the Shortcut, sign it with Apple and save it to a file.
	/// - Parameters:
	///   - path: path to save the file
	///   - sign: After iOS 13.0, you can't install unsigned shortcut file. You must sign the file in order to install it into `Shortcut` app. You should be aware that this `shortcuts sign` command can only run on mac with AppleID login.
	///   - Throws: An error of type `EncodingError`, if one is thrown during the encoding process. Or any error during the `shortcuts sign` and save file process.
	public func buildAndSave(toPath path: URL, sign: Bool = true) throws {
		let data = try build()
		try data.write(to: path)
		try ShortcutSign(path: path, signMode: .anyone).run()
	}
}

struct ShortcutSign {
	enum SignMode: String {
		case peopleWhoKnowMe = "people-who-know-me"
		case anyone
	}
	
	enum Error: Swift.Error {
		case signFailed
	}
	
	let path: URL
	let signMode: SignMode
	
	private let fm = FileManager.default
	
	func run() throws {
		let outputPath = URL(fileURLWithPath: path.relativeString.replacingOccurrences(of: ".shortcut", with: "-signed.shortcut"))
		if fm.fileExists(atPath: outputPath.relativeString) {
			try fm.removeItem(at: outputPath)
		}
		let output = SwiftShell.run(
			"shortcuts", "sign",
			"--mode", signMode.rawValue,
			"--input", path.relativeString,
			"--output", outputPath.relativeString
		)
		print(output.stdout)
		if !fm.fileExists(atPath: outputPath.relativeString) {
			throw output.error ?? Error.signFailed
		}
		try fm.removeItem(at: path)
		try fm.moveItem(at: outputPath, to: path)
	}
}
