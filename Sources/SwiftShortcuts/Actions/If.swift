import Foundation

public struct If: Shortcut {
    let condition: Condition
    let ifTrue: AnyShortcut
    let ifFalse: AnyShortcut?
    let groupingIdentifier: UUID

    let identifier = "is.workflow.actions.conditional"

    public var body: some Shortcut {
        ShortcutGroup {
            ControlFlowAction(identifier: identifier, groupingIdentifier: groupingIdentifier, mode: .start, userInfo: condition)
            ifTrue

            #if swift(>=5.3)
            if let ifFalse = ifFalse {
                ControlFlowAction(identifier: identifier, groupingIdentifier: groupingIdentifier, mode: .middle)
                ifFalse
            }
            #else
            ifFalse.map { ifFalse in
                ShortcutGroup {
                    ControlFlowAction(identifier: identifier, groupingIdentifier: groupingIdentifier, mode: .middle)
                    ifFalse
                }
            }
            #endif

            ControlFlowAction(identifier: identifier, groupingIdentifier: groupingIdentifier, mode: .end)
        }
    }

    public init<TrueContent>(_ condition: Condition, groupingIdentifier: UUID = UUID(), @ShortcutBuilder then ifTrue: () -> TrueContent) where TrueContent: Shortcut {
        self.condition = condition
        self.ifTrue = AnyShortcut(ifTrue())
        self.ifFalse = nil
        self.groupingIdentifier = groupingIdentifier
    }

    public init<TrueContent, FalseContent>(_ condition: Condition, groupingIdentifier: UUID = UUID(), @ShortcutBuilder then ifTrue: () -> TrueContent, @ShortcutBuilder else ifFalse: () -> FalseContent) where TrueContent: Shortcut, FalseContent: Shortcut {
        self.condition = condition
        self.ifTrue = AnyShortcut(ifTrue())
        self.ifFalse = AnyShortcut(ifFalse())
        self.groupingIdentifier = groupingIdentifier
    }
}
