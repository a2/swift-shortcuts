extension VariableValue: ExpressibleByBooleanLiteral where Value: ExpressibleByBooleanLiteral {
    /// Creates an instance initialized to the given Boolean value.
    /// - Parameter value: The value of the new instance.
    public init(booleanLiteral value: Value.BooleanLiteralType) {
        self = .value(Value(booleanLiteral: value))
    }
}

extension VariableValue: ExpressibleByExtendedGraphemeClusterLiteral where Value: ExpressibleByExtendedGraphemeClusterLiteral {
    /// Creates an instance initialized to the given value.
    /// - Parameter value: The value of the new instance.
    public init(extendedGraphemeClusterLiteral value: Value.ExtendedGraphemeClusterLiteralType) {
        self = .value(Value(extendedGraphemeClusterLiteral: value))
    }
}

extension VariableValue: ExpressibleByFloatLiteral where Value: ExpressibleByFloatLiteral {
    /// Creates an instance initialized to the specified floating-point value.
    ///
    /// - Attention: Do not call this initializer directly. Instead, initialize a variable or constant using a floating-point literal.
    ///
    /// - Parameter value: The value of the new instance.
    public init(floatLiteral value: Value.FloatLiteralType) {
        self = .value(Value(floatLiteral: value))
    }
}

extension VariableValue: ExpressibleByIntegerLiteral where Value: ExpressibleByIntegerLiteral {
    /// Creates an instance initialized to the specified integer value.
    ///
    /// - Attention: Do not call this initializer directly. Instead, initialize a variable or constant using an integer literal.
    ///
    /// - Parameter value: The value of the new instance.
    public init(integerLiteral value: Value.IntegerLiteralType) {
        self = .value(Value(integerLiteral: value))
    }
}

extension VariableValue: ExpressibleByNilLiteral where Value: ExpressibleByNilLiteral {
    /// Creates an instance initialized with `nil`.
    ///
    /// - Attention: Do not call this initializer directly. Instead, initialize a variable or constant using a nil literal.
    ///
    /// - Parameter nilLiteral: An empty tuple.
    public init(nilLiteral: ()) {
        self = .value(Value(nilLiteral: nilLiteral))
    }
}

extension VariableValue: ExpressibleByStringLiteral where Value: ExpressibleByStringLiteral {
    /// Creates an instance initialized to the given string value.
    ///
    /// - Attention: Do not call this initializer directly. Instead, initialize a variable or constant using a string literal.
    ///
    /// - Parameter value: The value of the new instance.
    public init(stringLiteral value: Value.StringLiteralType) {
        self = .value(Value(stringLiteral: value))
    }
}

extension VariableValue: ExpressibleByUnicodeScalarLiteral where Value: ExpressibleByUnicodeScalarLiteral {
    /// Creates an instance initialized to the given value.
    ///
    /// - Attention: Do not call this initializer directly. Instead, initialize a variable or constant using a unicode scalar literal.
    ///
    /// - Parameter value: The value of the new instance.
    public init(unicodeScalarLiteral value: Value.UnicodeScalarLiteralType) {
        self = .value(Value(unicodeScalarLiteral: value))
    }
}
