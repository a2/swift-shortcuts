import Foundation

extension Shortcut {
    var payload: ShortcutPayload {
        let decomposed = body.decompose()
        let encodableActionComponents = decomposed.map { actionStep in actionStep.encodable() }
        return ShortcutPayload(actions: encodableActionComponents)
    }

    /// Serializes the body of the Shortcut to a file format suitable for opening in the Shortcuts app.
    /// - Throws: An error of type `EncodingError`, if one is thrown during the encoding process.
    /// - Returns: The binary data representing this Shortcut.
    public func build() throws -> Data {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .binary
        return try encoder.encode(payload)
    }
}
