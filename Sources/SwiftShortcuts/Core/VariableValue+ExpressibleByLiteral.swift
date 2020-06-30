extension VariableValue: ExpressibleByBooleanLiteral where Value: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Value.BooleanLiteralType) {
        self = .value(Value(booleanLiteral: value))
    }
}

extension VariableValue: ExpressibleByExtendedGraphemeClusterLiteral where Value: ExpressibleByExtendedGraphemeClusterLiteral {
    public init(extendedGraphemeClusterLiteral value: Value.ExtendedGraphemeClusterLiteralType) {
        self = .value(Value(extendedGraphemeClusterLiteral: value))
    }
}

extension VariableValue: ExpressibleByFloatLiteral where Value: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Value.FloatLiteralType) {
        self = .value(Value(floatLiteral: value))
    }
}

extension VariableValue: ExpressibleByIntegerLiteral where Value: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Value.IntegerLiteralType) {
        self = .value(Value(integerLiteral: value))
    }
}

extension VariableValue: ExpressibleByNilLiteral where Value: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self = .value(Value(nilLiteral: nilLiteral))
    }
}

extension VariableValue: ExpressibleByStringLiteral where Value: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self = .value(Value(stringLiteral: value as! Value.StringLiteralType))
    }
}

extension VariableValue: ExpressibleByUnicodeScalarLiteral where Value: ExpressibleByUnicodeScalarLiteral {
    public init(unicodeScalarLiteral value: Value.UnicodeScalarLiteralType) {
        self = .value(Value(unicodeScalarLiteral: value))
    }
}
