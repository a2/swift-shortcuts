/// A value that can be stored in a dictionary in the Shortcuts app.
public enum DictionaryValue {
    /// A string value.
    case string(Text)

    /// A numeric value, stored as Text.
    case number(Text)

    /// A Boolean value or a variable representing one.
    case boolean(VariableValue<Bool>)

    /// A dictionary of other values.
    case dictionary([(key: Text, value: DictionaryValue)])

    /// An array of other dictionary values.
    case array([DictionaryValue])
}

// MARK: - Convenience Constructors

extension DictionaryValue {
    /// This convenience constructor converts the `Variable` into a variable value.
    /// - Parameter variable: A variable.
    /// - Returns: A Boolean dictionary value.
    public static func boolean(_ variable: Variable) -> DictionaryValue {
        .boolean(VariableValue(variable))
    }

    /// This convenience constructor converts the `Bool` into a variable value.
    /// - Parameter value: A Boolean value.
    /// - Returns: A Boolean dictionary value.
    public static func boolean(_ value: Bool) -> DictionaryValue {
        .boolean(VariableValue(value))
    }

    /// This convenience constructor converts the `Number` into a `Text`.
    /// - Parameter value: A numeric value.
    /// - Returns: A dictionary value.
    public static func number(_ value: Number) -> DictionaryValue {
        .number("\(literal: value)")
    }

    /// This convenience constructor converts the ordered KeyValuePairs collection into an Array of tuples.
    /// - Parameter value: A dictionary literal.
    /// - Returns: A dictionary value.
    public static func dictionary(_ value: KeyValuePairs<Text, DictionaryValue>) -> DictionaryValue {
        .dictionary(Array(value))
    }
}

extension DictionaryValue: Encodable {
    /// Encodes this value into the given encoder.
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: This function throws an error if any values are invalid for the given encoder's format.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(KeyedValue(key: nil, value: self))
    }
}

extension DictionaryValue: ExpressibleByArrayLiteral {
    /// Creates an instance initialized with the given elements.
    /// - Parameter value: The value of the new instance.
    public init(arrayLiteral elements: DictionaryValue...) {
        self = .array(elements)
    }
}

extension DictionaryValue: ExpressibleByBooleanLiteral {
    /// Creates an instance initialized to the given Boolean value.
    ///
    /// - Attention: Do not call this initializer directly. Instead, initialize a variable or constant using one of the Boolean literals `true` and `false`.
    ///
    /// - Parameter value: The value of the new instance.
    public init(booleanLiteral value: Bool) {
        self = .boolean(.init(value))
    }
}

extension DictionaryValue: ExpressibleByDictionaryLiteral {
    /// Creates an instance initialized with the given key-value pairs.
    ///
    /// - Attention: Do not call this initializer directly. Instead, initialize a variable or constant using a dictionary literal.
    ///
    /// - Parameter value: The value of the new instance.
    public init(dictionaryLiteral elements: (Text, DictionaryValue)...) {
        self = .dictionary(elements)
    }
}

extension DictionaryValue: ExpressibleByIntegerLiteral {
    /// Creates an instance initialized to the specified integer value.
    ///
    /// - Attention: Do not call this initializer directly. Instead, initialize a variable or constant using an integer literal.
    ///
    /// - Parameter value: The value of the new instance.
    public init(integerLiteral value: Int) {
        self = .number("\(literal: value)")
    }
}

extension DictionaryValue: ExpressibleByFloatLiteral {
    /// Creates an instance initialized to the specified floating-point value.
    ///
    /// - Attention: Do not call this initializer directly. Instead, initialize a variable or constant using a floating-point literal.
    ///
    /// - Parameter value: The value of the new instance.
    public init(floatLiteral value: Double) {
        self = .number("\(literal: value)")
    }
}

extension DictionaryValue: ExpressibleByStringLiteral {
    /// Creates an instance initialized to the given string value.
    ///
    /// - Attention: Do not call this initializer directly. Instead, initialize a variable or constant using a string literal.
    ///
    /// - Parameter value: The value of the new instance.
    public init(stringLiteral value: String) {
        self = .string(Text(value))
    }
}

extension DictionaryValue: ExpressibleByStringInterpolation {
    /// Creates an instance from a string interpolation.
    ///
    /// - Attention: Do not call this initializer directly. Instead, initialize a variable or constant using an interpolated string literal.
    ///
    /// - Parameter stringInterpolation: An instance of `StringInterpolation` which has had each segment of the string literal appended to it.
    public init(stringInterpolation: Text.StringInterpolation) {
        self = .string(Text(stringInterpolation: stringInterpolation))
    }
}
