import Foundation

/// Represents a value that can be converted into a variable date value, such as a `Variable` or a `Date`.
///
/// - See Also: `FileFiltering`
public protocol VariableDateValueConvertible {
    /// A variable date value that represents this value.
    var variableDateValue: VariableValue<Date> { get }
}

extension Date: VariableDateValueConvertible {
    /// A variable date value that represents this value.
    public var variableDateValue: VariableValue<Date> { .value(self) }
}

extension Variable: VariableDateValueConvertible {
    /// A variable date value that represents this value.
    public var variableDateValue: VariableValue<Date> { .variable(self) }
}
