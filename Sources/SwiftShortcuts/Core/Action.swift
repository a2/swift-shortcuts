/// An smallest representable unit of a shortcut, consistent of an identifier and encodable parameters.
public struct Action: Shortcut {
    let identifier: String
    let parameters: AnyEncodable

    /// Initalizes the shortcut with empty parameters.
    /// - Parameter identifier: The identifier of the action as used by the Shortcuts app.
    public init(identifier: String) {
        self.init(identifier: identifier, parameters: EmptyParameters())
    }

    /// Initializes the shortcut.
    /// - Parameters:
    ///   - identifier: The identifier of the action as used by the Shortcuts app.
    ///   - parameters: The encodable parameter payload as used by the Shortcuts app.
    public init<Parameters>(identifier: String, parameters: Parameters) where Parameters: Encodable {
        self.identifier = identifier
        self.parameters = AnyEncodable(parameters)
    }

    public typealias Body = Never
    public var body: Never { fatalError() }

    func encodable() -> ActionWrapper {
        return ActionWrapper(self)
    }
}
