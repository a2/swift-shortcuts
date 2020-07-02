import Foundation

/// Repeats the contained actions, running them either a specified number of times or once for each item in an input list.
///
/// **Input:** (Anything) a list of items (optional)
///
/// **Result:** (Anything) Every item passed to the "End Repeat" action
public struct Repeat: Shortcut {
    enum Mode: Encodable {
        enum CodingKeys: String, CodingKey {
            case count = "WFRepeatCount"
            case input = "WFInput"
        }

        case each(Variable)
        case count(Int)

        var identifier: String {
            switch self {
            case .each:
                return "is.workflow.actions.repeat.each"
            case .count:
                return "is.workflow.actions.repeat.count"
            }
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            switch self {
            case .count(let count):
                try container.encode(count, forKey: .count)
            case .each(let variable):
                try container.encode(variable, forKey: .input)
            }
        }
    }

    let content: AnyShortcut
    let groupingIdentifier: UUID
    let mode: Mode

    /// The contents of the shortcut.
    public var body: some Shortcut {
        ShortcutGroup {
            ControlFlowAction(identifier: mode.identifier, groupingIdentifier: groupingIdentifier, mode: .start, userInfo: mode)
            content
            ControlFlowAction(identifier: mode.identifier, groupingIdentifier: groupingIdentifier, mode: .end)
        }
    }

    /// Initializes the shortcut.
    /// - Parameters:
    ///   - count: The number of times to repeat the actions.
    ///   - groupingIdentifier: An optional UUID, useful for building deterministic output.
    ///   - builder: The shortcut builder that creates shortcuts.
    ///   - repeatIndex: The index of current iteration as a variable.
    public init<Content>(count: Int, groupingIdentifier: UUID = UUID(), @ShortcutBuilder builder: (_ repeatIndex: Variable) -> Content) where Content: Shortcut {
        let repeatIndex = Variable(value: Attachment(type: .variable, variableName: "Repeat Index"))
        self.content = AnyShortcut(builder(repeatIndex))
        self.groupingIdentifier = groupingIdentifier
        self.mode = .count(count)
    }

    /// Initializes the shortcut.
    /// - Parameters:
    ///   - variable: An input list to iterate.
    ///   - groupingIdentifier: An optional UUID, useful for building deterministic output.
    ///   - builder: The shortcut builder that creates shortcuts.
    ///   - repeatIndex: The index of current iteration as a variable.
    ///   - repeatItem: The currently iterated item as a variable.
    public init<Content>(iterating variable: Variable, groupingIdentifier: UUID = UUID(), @ShortcutBuilder builder: (_ repeatIndex: Variable, _ repeatItem: Variable) -> Content) where Content: Shortcut {
        let repeatIndex = Variable(value: Attachment(type: .variable, variableName: "Repeat Index"))
        let repeatItem = Variable(value: Attachment(type: .variable, variableName: "Repeat Item"))
        self.content = AnyShortcut(builder(repeatIndex, repeatItem))
        self.groupingIdentifier = groupingIdentifier
        self.mode = .each(variable)
    }
}
