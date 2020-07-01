/// An enum that represents either a `Variable` or a value of the generic type `Value`
public enum VariableValue<Value> {
    /// This variable value represents a value.
    case value(Value)

    /// This variable value represents a variable.
    case variable(Variable)

    /// A convenience initializer for values.
    /// - Parameter value: The `Value` value to store.
    public init(_ value: Value) {
        self = .value(value)
    }

    /// A convenience initializer for variables.
    /// - Parameter variable: The `Variable` value to store.
    public init(_ variable: Variable) {
        self = .variable(variable)
    }
}
