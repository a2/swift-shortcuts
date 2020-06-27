import Foundation

public class Variable: Encodable {
    enum SerializationType: String, Encodable {
        case textTokenAttachment = "WFTextTokenAttachment"
    }

    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case serializationType = "WFSerializationType"
    }

    var value: Attachment
    var serializationType = SerializationType.textTokenAttachment

    init(value: Attachment) {
        self.value = value
    }

    public init(name: String? = nil) {
        self.value = Attachment(type: .actionOutput, outputName: name, outputUUID: UUID())
    }

    public func withDateFormat(_ dateFormat: Aggrandizement.DateFormatStyle) -> Variable {
        var newValue = value
        newValue.aggrandizements = [.coercion(class: .date), .dateFormat(dateFormat)]
        return Variable(value: newValue)
    }

    public func withPropertyName(_ propertyName: Aggrandizement.PropertyName, userInfo: Aggrandizement.PropertyUserInfo) -> Variable {
        var newValue = value
        newValue.aggrandizements = [.property(name: propertyName, userInfo: userInfo)]
        return Variable(value: newValue)
    }

    public func withValue(for key: String?) -> Variable {
        var newValue = value
        newValue.aggrandizements = [.coercion(class: .dictionary), .dictionaryValue(key: key)]
        return Variable(value: newValue)
    }

    public func withType(_ type: Aggrandizement.CoercionItemClass) -> Variable {
        var newValue = value
        newValue.aggrandizements = [.coercion(class: type)]
        return Variable(value: newValue)
    }

    func copyProperties(from variable: Variable) {
        value = variable.value
        serializationType = variable.serializationType
    }

    public func encode(to encoder: Encoder) throws {
        switch value.type {
        case .lastResult:
            fatalError("Attempted to encode a `Variable.lastResult`. Declare variable dependencies with the VariableDependency property wrapper and register them in the ActionContext.")
        default:
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(value, forKey: .value)
            try container.encode(serializationType, forKey: .serializationType)
        }
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

    public class var lastResult: Variable {
        Variable(value: Attachment(type: .lastResult))
    }
}

@propertyWrapper public struct OutputVariable {
    public let wrappedValue: Variable

    public var projectedValue: OutputVariable { self }

    public init(wrappedValue: Variable = Variable()) {
        self.wrappedValue = wrappedValue
    }
}
