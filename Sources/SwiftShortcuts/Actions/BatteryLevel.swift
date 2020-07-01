/// The "Battery Level" shortcut.
public struct BatteryLevel: Shortcut {
    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.getbatterylevel")
    }

    /// Initializes a "Battery Level" shortcut.
    public init() {}
}
