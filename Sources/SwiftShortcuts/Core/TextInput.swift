enum TextInput {
    case variable(Variable)
    case interpolatedText(InterpolatedText)
}

extension TextInput: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .variable(let variable):
            try container.encode(variable)
        case .interpolatedText(let interpolatedText):
            try container.encode(interpolatedText)
        }
    }
}
