import Foundation

extension Shortcut {
    var payload: ShortcutPayload {
        let decomposed = body.decompose()
        let encodableActionComponents = decomposed.map { actionStep in actionStep.encodable() }
        return ShortcutPayload(actions: encodableActionComponents)
    }

    public func build() throws -> Data {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .binary
        return try encoder.encode(payload)
    }
}
