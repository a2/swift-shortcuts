import Foundation

public class Variable {
    enum SerializationType: String, Hashable, Encodable {
        case textTokenAttachment = "WFTextTokenAttachment"
    }

    let value: Attachment
    let serializationType = SerializationType.textTokenAttachment

    init(value: Attachment) {
        self.value = value
    }

    public init(name: String? = nil, uuid: UUID = UUID()) {
        self.value = Attachment(type: .actionOutput, outputName: name, outputUUID: uuid)
    }

    public func withDateFormat(_ dateFormat: DateFormatStyle) -> Variable {
        var newValue = value
        newValue.aggrandizements = [.coercion(class: .date), .dateFormat(dateFormat)]
        return Variable(value: newValue)
    }

    public func withPropertyName(_ propertyName: PropertyName, userInfo: PropertyUserInfo) -> Variable {
        var newValue = value
        newValue.aggrandizements = [.property(name: propertyName, userInfo: userInfo)]
        return Variable(value: newValue)
    }

    public func withValue(for key: String?) -> Variable {
        var newValue = value
        newValue.aggrandizements = [.coercion(class: .dictionary), .dictionaryValue(key: key)]
        return Variable(value: newValue)
    }

    public func withType(_ type: CoercionItemClass) -> Variable {
        var newValue = value
        newValue.aggrandizements = [.coercion(class: type)]
        return Variable(value: newValue)
    }
}

extension Variable: Equatable {
    public static func == (lhs: Variable, rhs: Variable) -> Bool {
        lhs.serializationType == rhs.serializationType && lhs.value == rhs.value
    }
}

extension Variable: Hashable {
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

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .value)
        try container.encode(serializationType, forKey: .serializationType)
    }
}

extension Variable {
    public class var askEachTime: Variable {
        Variable(value: Attachment(type: .askEachTime))
    }

    public class var clipboard: Variable {
        Variable(value: Attachment(type: .clipboard))
    }

    public class var currentDate: Variable {
        Variable(value: Attachment(type: .currentDate))
    }

    public class var shortcutInput: Variable {
        Variable(value: Attachment(type: .shortcutInput))
    }
}

@propertyWrapper public struct OutputVariable {
    public let wrappedValue: Variable

    public var projectedValue: OutputVariable { self }

    public init(wrappedValue: Variable = Variable()) {
        self.wrappedValue = wrappedValue
    }
}
