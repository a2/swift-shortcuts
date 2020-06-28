import Foundation

public struct Repeat: Action {
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

    let content: AnyAction
    let groupingIdentifier: UUID
    let mode: Mode

    public var body: some Action {
        ActionGroup {
            ControlFlowAction(identifier: mode.identifier, groupingIdentifier: groupingIdentifier, mode: .start, userInfo: mode)
            content
            ControlFlowAction(identifier: mode.identifier, groupingIdentifier: groupingIdentifier, mode: .end)
        }
    }

    public init<Content>(count: Int, groupingIdentifier: UUID = UUID(), @ActionBuilder builder: (_ repeatIndex: Variable) -> Content) where Content: Action {
        let repeatIndex = Variable(value: Attachment(type: .variable, variableName: "Repeat Index"))
        self.content = AnyAction(builder(repeatIndex))
        self.groupingIdentifier = groupingIdentifier
        self.mode = .count(count)
    }

    public init<Content>(iterating variable: Variable, groupingIdentifier: UUID = UUID(), @ActionBuilder builder: (_ repeatIndex: Variable, _ repeatItem: Variable) -> Content) where Content: Action {
        let repeatIndex = Variable(value: Attachment(type: .variable, variableName: "Repeat Index"))
        let repeatItem = Variable(value: Attachment(type: .variable, variableName: "Repeat Item"))
        self.content = AnyAction(builder(repeatIndex, repeatItem))
        self.groupingIdentifier = groupingIdentifier
        self.mode = .each(variable)
    }
}
