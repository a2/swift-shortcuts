public enum MultipartFormValue {
    case string(Text)
    case file(Variable)
}

extension MultipartFormValue: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .string(Text(value))
    }
}

extension MultipartFormValue: ExpressibleByStringInterpolation {
    public init(stringInterpolation: Text.StringInterpolation) {
        self = .string(Text(stringInterpolation: stringInterpolation))
    }
}
