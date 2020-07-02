import Foundation

/// Tests if a condition is true, and if so, runs the actions inside. Otherwise, the actions under "Otherwise" are run.
///
/// **Input:** Anything
///
/// **Result:** (Anything) The input
public struct If: Shortcut {
    let condition: Condition
    let ifTrue: AnyShortcut
    let ifFalse: AnyShortcut?
    let groupingIdentifier: UUID

    let identifier = "is.workflow.actions.conditional"

    /// The contents of the shortcut.
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

    /// Initializes the shortcut with no "else" branch.
    /// - Parameters:
    ///   - condition: The evaluated logic that determines which branch to follow.
    ///   - groupingIdentifier: An optional UUID, useful for building deterministic output.
    ///   - ifTrue: The shortcut builder that creates shortcuts for the "then" branch.
    public init<TrueContent>(_ condition: Condition, groupingIdentifier: UUID = UUID(), @ShortcutBuilder then ifTrue: () -> TrueContent) where TrueContent: Shortcut {
        self.condition = condition
        self.ifTrue = AnyShortcut(ifTrue())
        self.ifFalse = nil
        self.groupingIdentifier = groupingIdentifier
    }

    /// Initializes the shortcut with both "then" and "else" branches.
    /// - Parameters:
    ///   - condition: The evaluated logic that determines which branch to follow.
    ///   - groupingIdentifier: An optional UUID, useful for building deterministic output.
    ///   - ifTrue: The shortcut builder that creates shortcuts for the "then" branch.
    ///   - ifTrue: The shortcut builder that creates shortcuts for the "else" branch.
    public init<TrueContent, FalseContent>(_ condition: Condition, groupingIdentifier: UUID = UUID(), @ShortcutBuilder then ifTrue: () -> TrueContent, @ShortcutBuilder else ifFalse: () -> FalseContent) where TrueContent: Shortcut, FalseContent: Shortcut {
        self.condition = condition
        self.ifTrue = AnyShortcut(ifTrue())
        self.ifFalse = AnyShortcut(ifFalse())
        self.groupingIdentifier = groupingIdentifier
    }
}
