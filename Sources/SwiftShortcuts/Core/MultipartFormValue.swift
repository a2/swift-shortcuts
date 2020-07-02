/// A multipart form value of either a string (`Text`) or a file (a `Variable`'s contents).
public enum MultipartFormValue {
    /// A textual form value.
    case string(Text)

    /// A variable form value.
    case file(Variable)
}

extension MultipartFormValue: ExpressibleByStringLiteral {
    /// Creates an instance initialized to the given string value.
    ///
    /// - Attention: Do not call this initializer directly. Instead, initialize a variable or constant using a string literal.
    ///
    /// - Parameter value: The value of the new instance.
    public init(stringLiteral value: String) {
        self = .string(Text(value))
    }
}

extension MultipartFormValue: ExpressibleByStringInterpolation {
    /// Creates an instance from a string interpolation.
    ///
    /// - Attention: Do not call this initializer directly. Instead, initialize a variable or constant using an interpolated string literal.
    ///
    /// - Parameter stringInterpolation: An instance of `StringInterpolation` which has had each segment of the string literal appended to it.
    public init(stringInterpolation: Text.StringInterpolation) {
        self = .string(Text(stringInterpolation: stringInterpolation))
    }
}
