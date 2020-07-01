import Foundation

/// A wrapper for a numeric type supported by the Shortcuts app.
public struct Number: Hashable {
    enum Storage: Hashable {
        case signed(Int64)
        case unsigned(UInt64)
        case float(Float)
        case double(Double)
    }

    let storage: Storage

    /// An `NSNumber` representation of `storage` for use in comparison and equality.
    var number: NSNumber {
        switch storage {
        case .signed(let value):
            return NSNumber(value: value)
        case .unsigned(let value):
            return NSNumber(value: value)
        case .float(let value):
            return NSNumber(value: value)
        case .double(let value):
            return NSNumber(value: value)
        }
    }

    /// Returns a number initialized to contain a given value, treated as an Int8.
    /// - Parameter value: The value for the new number.
    public init(_ value: Int8) {
        self.storage = .signed(Int64(value))
    }

    /// Returns a number initialized to contain a given value, treated as an Int16.
    /// - Parameter value: The value for the new number.
    public init(_ value: Int16) {
        self.storage = .signed(Int64(value))
    }

    /// Returns a number initialized to contain a given value, treated as an Int32.
    /// - Parameter value: The value for the new number.
    public init(_ value: Int32) {
        self.storage = .signed(Int64(value))
    }

    /// Returns a number initialized to contain a given value, treated as an Int64.
    /// - Parameter value: The value for the new number.
    public init(_ value: Int64) {
        self.storage = .signed(Int64(value))
    }

    /// Returns a number initialized to contain a given value, treated as an integer of platform-dependent size.
    /// - Parameter value: The value for the new number.
    public init(_ value: Int) {
        self.storage = .signed(Int64(value))
    }

    /// Returns a number initialized to contain a given value, treated as a UInt8.
    /// - Parameter value: The value for the new number.
    public init(_ value: UInt8) {
        self.storage = .unsigned(UInt64(value))
    }

    /// Returns a number initialized to contain a given value, treated as a UInt16.
    /// - Parameter value: The value for the new number.
    public init(_ value: UInt16) {
        self.storage = .unsigned(UInt64(value))
    }

    /// Returns a number initialized to contain a given value, treated as a UInt32.
    /// - Parameter value: The value for the new number.
    public init(_ value: UInt32) {
        self.storage = .unsigned(UInt64(value))
    }

    /// Returns a number initialized to contain a given value, treated as a UInt64.
    /// - Parameter value: The value for the new number.
    public init(_ value: UInt64) {
        self.storage = .unsigned(UInt64(value))
    }

    /// Returns a number initialized to contain a given value, treated as a unsigned integer of platform-dependent size.
    /// - Parameter value: The value for the new number.
    public init(_ value: UInt) {
        self.storage = .unsigned(UInt64(value))
    }

    /// Returns a number initialized to contain a given value, treated as a double-precision floating-point value.
    /// - Parameter value: The value for the new number.
    public init(_ value: Double) {
        self.storage = .double(value)
    }

    /// Returns a number initialized to contain a given value, treated as a single-precision floating-point value.
    /// - Parameter value: The value for the new number.
    public init(_ value: Float) {
        self.storage = .float(value)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(number)
    }
}

extension Number: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch storage {
        case .unsigned(let value):
            try container.encode(value)
        case .signed(let value):
            try container.encode(value)
        case .float(let value):
            try container.encode(value)
        case .double(let value):
            try container.encode(value)
        }
    }
}

extension Number: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self.storage = .double(value)
    }
}

extension Number: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int64) {
        self.storage = .signed(value)
    }
}

extension Number: CustomStringConvertible {
    public var description: String {
        switch storage {
        case .signed(let value):
            return String(describing: value)
        case .unsigned(let value):
            return String(describing: value)
        case .float(let value):
            return String(describing: value)
        case .double(let value):
            return String(describing: value)
        }
    }
}

extension Number: Comparable {
    public static func < (lhs: Number, rhs: Number) -> Bool {
        return lhs.number.compare(rhs.number) == .orderedAscending
    }
}

extension Number: Equatable {
    public static func == (lhs: Number, rhs: Number) -> Bool {
        return lhs.number == rhs.number
    }
}
