@propertyWrapper public struct OutputVariable {
    public let wrappedValue: Variable

    public var projectedValue: OutputVariable { self }

    public init(wrappedValue: Variable = Variable()) {
        self.wrappedValue = wrappedValue
    }
}
