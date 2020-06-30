public enum MultipartFormValue {
    case string(InterpolatedText)
    case file(Variable)
}

extension MultipartFormValue: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .string(InterpolatedText(value))
    }
}

extension MultipartFormValue: ExpressibleByStringInterpolation {
    public init(stringInterpolation: InterpolatedText.StringInterpolation) {
        self = .string(InterpolatedText(stringInterpolation: stringInterpolation))
    }
}
