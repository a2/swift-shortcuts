import Foundation

public struct Number {
    enum Storage {
        case signed(Int64)
        case unsigned(UInt64)
        case float(Float)
        case double(Double)
    }

    let storage: Storage

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

    public init(_ value: Int8) {
        self.storage = .signed(Int64(value))
    }

    public init(_ value: Int16) {
        self.storage = .signed(Int64(value))
    }

    public init(_ value: Int32) {
        self.storage = .signed(Int64(value))
    }

    public init(_ value: Int64) {
        self.storage = .signed(Int64(value))
    }

    public init(_ value: Int) {
        self.storage = .signed(Int64(value))
    }

    public init(_ value: UInt8) {
        self.storage = .unsigned(UInt64(value))
    }

    public init(_ value: UInt16) {
        self.storage = .unsigned(UInt64(value))
    }

    public init(_ value: UInt32) {
        self.storage = .unsigned(UInt64(value))
    }

    public init(_ value: UInt64) {
        self.storage = .unsigned(UInt64(value))
    }

    public init(_ value: UInt) {
        self.storage = .unsigned(UInt64(value))
    }

    public init(_ value: Double) {
        self.storage = .double(value)
    }

    public init(_ value: Float) {
        self.storage = .float(value)
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
