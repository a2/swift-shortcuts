import Foundation

extension UUID {
    /// A deterministic, auto-incrementing "UUID" generator for testing.
    static var incrementing: () -> UUID {
        var uuid = 0
        return {
            defer { uuid += 1 }
            return UUID(uuidString: "00000000-0000-0000-0000-\(String(format: "%012x", uuid))")!
        }
    }
}
