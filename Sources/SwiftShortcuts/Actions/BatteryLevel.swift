public struct BatteryLevel: Action {
    public var body: some Action {
        ActionStep(identifier: "is.workflow.actions.getbatterylevel")
    }

    public init() {}
}
