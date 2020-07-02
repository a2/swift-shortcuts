import Foundation

/// A variable is a container used to label and store content such as text, images, a webpage, or a dictionary of data.
public class Variable {
    let value: Attachment
    let serializationType = SerializationType.textTokenAttachment

    init(value: Attachment) {
        self.value = value
    }

    /// Initializes a variable.
    /// - Parameters:
    ///   - name: A custom name for the variable to display in the Shortcuts app.
    ///   - uuid: The internal UUID of the variable, useful for building deterministic output.
    public init(name: String? = nil, uuid: UUID = UUID()) {
        self.value = Attachment(type: .actionOutput, outputName: name, outputUUID: uuid)
    }

    /// A copy of this variable coerced into a Date with the specified date format style.
    /// - Parameter dateFormatStlye: The date format.
    /// - Returns: A modified copy of this value.
    public func withDateFormat(_ dateFormatStlye: DateFormatStyle) -> Variable {
        var newValue = value
        newValue.aggrandizements = [.coercion(class: .date), .dateFormat(dateFormatStlye)]
        return Variable(value: newValue)
    }

    /// A copy of this variable with the value for a specified property name.
    /// - Parameters:
    ///   - propertyName: The property name whose value to fetch.
    ///   - userInfo: Optional user info that depends on the property name.
    /// - Returns: A modified copy of this value.
    public func withPropertyName(_ propertyName: PropertyName, userInfo: PropertyUserInfo? = nil) -> Variable {
        var newValue = value
        newValue.aggrandizements = [.property(name: propertyName, userInfo: userInfo)]
        return Variable(value: newValue)
    }

    /// A copy of this variable coerced into a Dictionary with the value for a specified key.
    /// - Parameter key: The key whose value to fetch. If nil, returns the entire dictionary.
    /// - Returns: A modified copy of this value.
    public func withValue(for key: String?) -> Variable {
        var newValue = value
        newValue.aggrandizements = [.coercion(class: .dictionary), .dictionaryValue(key: key)]
        return Variable(value: newValue)
    }

    /// A copy of this variable coerced into a value of the specified type.
    /// - Parameter type: The new type of the value.
    /// - Returns: A modified copy of this value.
    public func withType(_ type: CoercionItemClass) -> Variable {
        var newValue = value
        newValue.aggrandizements = [.coercion(class: type)]
        return Variable(value: newValue)
    }
}

extension Variable: Equatable {
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    ///
    /// - Returns: True if the two values are equal, false otherwise.
    public static func == (lhs: Variable, rhs: Variable) -> Bool {
        lhs.serializationType == rhs.serializationType && lhs.value == rhs.value
    }
}

extension Variable: Hashable {
    /// Hashes the essential components of this value by feeding them into the given hasher.
    /// - Parameter hasher: The hasher to use when combining the components of this instance.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
        hasher.combine(serializationType)
    }
}

extension Variable: Encodable {
    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case serializationType = "WFSerializationType"
    }

    /// Encodes this value into the given encoder.
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: This function throws an error if any values are invalid for the given encoder's format.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .value)
        try container.encode(serializationType, forKey: .serializationType)
    }
}

// MARK: - Global Variables

extension Variable {
    /// When the shortcut is run, asks for input from the user.
    public class var askEachTime: Variable {
        Variable(value: Attachment(type: .askEachTime))
    }

    /// When the shortcut is run, returns the current clipboard contents.
    public class var clipboard: Variable {
        Variable(value: Attachment(type: .clipboard))
    }

    /// When the shortcut is run, returns the current date.
    public class var currentDate: Variable {
        Variable(value: Attachment(type: .currentDate))
    }

    /// When the shortcut is run, returns the shortcut input from the share sheet or similar.
    public class var shortcutInput: Variable {
        Variable(value: Attachment(type: .shortcutInput))
    }
}
