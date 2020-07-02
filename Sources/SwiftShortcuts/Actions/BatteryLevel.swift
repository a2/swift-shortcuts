/// Outputs the percentage of battery remaining as a number from 0 to 100.
/// 
/// **Result:** Number
public struct BatteryLevel: Shortcut {
    /// The contents of the shortcut.
    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.getbatterylevel")
    }

    /// Initializes the shortcut.
    public init() {}
}
