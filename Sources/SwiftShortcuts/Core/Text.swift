import Foundation

/// A representation of one or more lines of text that can be used in shortcuts.
public struct Text: Hashable {
    let string: String
    let variablesByRange: [Range<String.Index>: Variable]
    var allowsEncodingAsRawString = true

    /// Creates a text shortcut that represents a stored string without variables.
    /// - Parameter string: The string value to store.
    public init(_ string: String) {
        self.string = string
        self.variablesByRange = [:]
    }

    var singleVariable: Variable? {
        guard string.index(string.startIndex, offsetBy: 1, limitedBy: string.endIndex) == string.endIndex else {
            return nil
        }

        guard variablesByRange.index(variablesByRange.startIndex, offsetBy: 1, limitedBy: variablesByRange.endIndex) == variablesByRange.endIndex else {
            return nil
        }

        return variablesByRange[variablesByRange.startIndex].value
    }
}

extension Text: ExpressibleByStringInterpolation {
    /// The string interpolation type used by `Text` that property encodes `Variable` values.
    public struct StringInterpolation: StringInterpolationProtocol {
        static var objectReplacementCharacter = "\u{fffc}"

        var string: String
        var variablesByRange: [Range<String.Index>: Variable]

        /// Creates a string interpolation with storage pre-sized for a literal
        /// with the indicated attributes.
        ///
        /// Do not call this initializer directly. It is used by the compiler when
        /// interpreting string interpolations.
        public init(literalCapacity: Int, interpolationCount: Int) {
            var value = ""
            value.reserveCapacity(literalCapacity)
            self.string = value
            self.variablesByRange = [Range<String.Index>: Variable](minimumCapacity: interpolationCount)
        }

        /// Appends a literal segment of a string interpolation.
        ///
        /// - Attention: Do not call this method directly. It is used by the compiler when
        /// interpreting string interpolations.
        public mutating func appendLiteral(_ literal: String) {
            string.append(literal)
        }

        /// Interpolates the given variable's runtime value into the string literal being created.
        ///
        /// - Attention: Do not call this method directly. It is used by the compiler when
        /// interpreting string interpolations.
        public mutating func appendInterpolation(_ variable: Variable) {
            let lowerBound = string.endIndex
            string.append(Self.objectReplacementCharacter)
            variablesByRange[lowerBound ..< string.endIndex] = variable
        }

        /// Interpolates the given value's textual representation into the
        /// string literal being created.
        ///
        /// - Attention: Do not call this method directly. It is used by the compiler when
        /// interpreting string interpolations.
        public mutating func appendInterpolation<T>(literal value: T) {
            string.append(String(describing: value))
        }
    }

    /// Creates an instance initialized to the given string value.
    ///
    /// - Attention: Do not call this initializer directly. Instead, initialize a variable or constant using a string literal.
    ///
    /// - Parameter value: The value of the new instance.
    public init(stringLiteral value: String) {
        self.string = value
        self.variablesByRange = [:]
    }

    /// Creates an instance from a string interpolation.
    ///
    /// - Attention: Do not call this initializer directly. Instead, initialize a variable or constant using an interpolated string literal.
    ///
    /// - Parameter stringInterpolation: An instance of `StringInterpolation` which has had each segment of the string literal appended to it.
    public init(stringInterpolation: StringInterpolation) {
        self.string = stringInterpolation.string
        self.variablesByRange = stringInterpolation.variablesByRange
    }
}

extension Text: Encodable {
    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case serializationType = "WFSerializationType"
    }

    enum ValueCodingKeys: String, CodingKey {
        case string = "string"
        case attachments = "attachmentsByRange"
    }

    /// Encodes this value into the given encoder.
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: This function throws an error if any values are invalid for the given encoder's format.
    public func encode(to encoder: Encoder) throws {
        if variablesByRange.isEmpty && allowsEncodingAsRawString {
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
