/// A property wrapper type for a `Variable` that allows for saving output from a `Shortcut`.
@propertyWrapper public struct OutputVariable {
    /// The underlying value referenced by the output variable.
    public let wrappedValue: Variable

    /// The output variable value.
    public var projectedValue: OutputVariable { self }

    /// Creates an output variable that can be written to.
    /// - Parameter wrappedValue: The underlying variable to write to.
    public init(wrappedValue: Variable = Variable()) {
        self.wrappedValue = wrappedValue
    }
}
