import Foundation

public struct If: Action {
    let condition: Condition
    let ifTrue: AnyAction
    let ifFalse: AnyAction?
    let groupingIdentifier: UUID

    let identifier = "is.workflow.actions.conditional"

    public var body: some Action {
        ActionGroup {
            ControlFlowAction(identifier: identifier, groupingIdentifier: groupingIdentifier, mode: .start, userInfo: condition)
            ifTrue

            if let ifFalse = ifFalse {
                ControlFlowAction(identifier: identifier, groupingIdentifier: groupingIdentifier, mode: .middle)
                ifFalse
            }

            ControlFlowAction(identifier: identifier, groupingIdentifier: groupingIdentifier, mode: .end)
        }
    }

    public init<TrueContent>(_ condition: Condition, groupingIdentifier: UUID = UUID(), @ActionBuilder then ifTrue: () -> TrueContent) where TrueContent: Action {
        self.condition = condition
        self.ifTrue = AnyAction(ifTrue())
        self.ifFalse = nil
        self.groupingIdentifier = groupingIdentifier
    }

    public init<TrueContent, FalseContent>(_ condition: Condition, groupingIdentifier: UUID = UUID(), @ActionBuilder then ifTrue: () -> TrueContent, @ActionBuilder else ifFalse: () -> FalseContent) where TrueContent: Action, FalseContent: Action {
        self.condition = condition
        self.ifTrue = AnyAction(ifTrue())
        self.ifFalse = AnyAction(ifFalse())
        self.groupingIdentifier = groupingIdentifier
    }
}
