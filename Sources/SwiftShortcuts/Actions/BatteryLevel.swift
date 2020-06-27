public struct BatteryLevel: Action {
    public var body: some Action {
        ActionComponent(identifier: "is.workflow.actions.getbatterylevel")
    }

    public init() {}
}
