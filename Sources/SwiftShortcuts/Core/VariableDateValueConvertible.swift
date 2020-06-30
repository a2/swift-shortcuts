import Foundation

public protocol VariableDateValueConvertible {
    var variableDateValue: VariableValue<Date> { get }
}

extension Date: VariableDateValueConvertible {
    public var variableDateValue: VariableValue<Date> { .value(self) }
}

extension Variable: VariableDateValueConvertible {
    public var variableDateValue: VariableValue<Date> { .variable(self) }
}
