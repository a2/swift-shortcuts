import Foundation

public struct InterpolatedText {
    public let string: String
    public let variablesByRange: [Range<String.Index>: Variable]
}

extension InterpolatedText: ExpressibleByStringInterpolation {
    public struct StringInterpolation: StringInterpolationProtocol {
        static var objectReplacementCharacter = "\u{fffc}"

        var string: String
        var variablesByRange: [Range<String.Index>: Variable]

        public init(literalCapacity: Int, interpolationCount: Int) {
            var value = ""
            value.reserveCapacity(literalCapacity)
            self.string = value
            self.variablesByRange = [Range<String.Index>: Variable](minimumCapacity: interpolationCount)
        }

        public mutating func appendLiteral(_ literal: String) {
            string.append(literal)
        }

        public mutating func appendInterpolation(_ variable: Variable) {
            let lowerBound = string.endIndex
            string.append(Self.objectReplacementCharacter)
            variablesByRange[lowerBound ..< string.endIndex] = variable
        }
    }

    public init(stringLiteral value: String) {
        self.string = value
        self.variablesByRange = [:]
    }

    public init(stringInterpolation: StringInterpolation) {
        self.string = stringInterpolation.string
        self.variablesByRange = stringInterpolation.variablesByRange
    }
}

extension InterpolatedText: Encodable {
    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case serializationType = "WFSerializationType"
    }

    enum ValueCodingKeys: String, CodingKey {
        case string = "string"
        case attachments = "attachmentsByRange"
    }

    enum SerializationType: String, Encodable {
        case textTokenString = "WFTextTokenString"
    }

    public func encode(to encoder: Encoder) throws {
        if variablesByRange.isEmpty {
            var container = encoder.singleValueContainer()
            try container.encode(string)
        } else {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(SerializationType.textTokenString, forKey: .serializationType)

            var nestedContainer = container.nestedContainer(keyedBy: ValueCodingKeys.self, forKey: .value)
            try nestedContainer.encode(string, forKey: .string)

            var attachmentsByRange = [String: Attachment](minimumCapacity: variablesByRange.count)
            for (range, variable) in variablesByRange {
                let rangeInString = NSRange(range, in: string)
                attachmentsByRange[String(describing: rangeInString)] = variable.value
            }

            try nestedContainer.encode(attachmentsByRange, forKey: .attachments)
        }
    }
}
