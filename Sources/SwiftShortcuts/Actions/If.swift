import Foundation

public struct If: Action {
    let condition: Condition
    let ifTrue: AnyAction
    let ifFalse: AnyAction?
    let groupingIdentifier: UUID

    let identifier = "is.workflow.actions.conditional"

    @ActionBuilder public var body: some Action {
        ControlFlowAction(identifier: identifier, groupingIdentifier: groupingIdentifier, mode: .start, userInfo: condition)
        ifTrue

        if let ifFalse = ifFalse {
            ControlFlowAction(identifier: identifier, groupingIdentifier: groupingIdentifier, mode: .middle)
            ifFalse
        }

        ControlFlowAction(identifier: identifier, groupingIdentifier: groupingIdentifier, mode: .end)
    }

    public init<TrueContent>(_ condition: Condition, groupingIdentifier: UUID = UUID(), @ActionBuilder if: () -> TrueContent) where TrueContent: Action {
        self.condition = condition
        self.ifTrue = AnyAction(`if`())
        self.ifFalse = nil
        self.groupingIdentifier = groupingIdentifier
    }

    public init<TrueContent, FalseContent>(_ condition: Condition, groupingIdentifier: UUID = UUID(), @ActionBuilder if: () -> TrueContent, @ActionBuilder else: () -> FalseContent) where TrueContent: Action, FalseContent: Action {
        self.condition = condition
        self.ifTrue = AnyAction(`if`())
        self.ifFalse = AnyAction(`else`())
        self.groupingIdentifier = groupingIdentifier
    }
}
