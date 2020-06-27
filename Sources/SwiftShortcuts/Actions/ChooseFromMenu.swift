import Foundation

public struct MenuItem {
    let label: String
    let action: AnyAction

    public init<Content>(label: String, @ActionBuilder action: () -> Content) where Content: Action {
        self.label = label
        self.action = AnyAction(action())
    }
}

public struct ChooseFromMenu: Action {
    struct StartUserInfo: Encodable {
        enum CodingKeys: String, CodingKey {
            case prompt = "WFMenuPrompt"
            case menuItems = "WFMenuItems"
        }

        let prompt: String
        let menuItems: [String]
    }

    struct MiddleUserInfo: Encodable {
        enum CodingKeys: String, CodingKey {
            case menuItemTitle = "WFMenuItemTitle"
        }

        let menuItemTitle: String
    }

    let identifier = "is.workflow.actions.choosefrommenu"

    public var body: some Action {
        ActionGroup {
            ControlFlowAction(identifier: identifier, groupingIdentifier: groupingIdentifier, mode: .start, userInfo: StartUserInfo(prompt: prompt, menuItems: items.map(\.label)))

            ForEach(items) { item in
                ControlFlowAction(identifier: identifier, groupingIdentifier: groupingIdentifier, mode: .middle, userInfo: MiddleUserInfo(menuItemTitle: item.label))
                item.action
            }

            ControlFlowAction(identifier: identifier, groupingIdentifier: groupingIdentifier, mode: .end)
        }
    }

    let prompt: String
    let items: [MenuItem]
    let groupingIdentifier: UUID

    public init(prompt: String = "", groupingIdentifier: UUID = UUID(), items: [MenuItem]) {
        self.prompt = prompt
        self.items = items
        self.groupingIdentifier = groupingIdentifier
    }
}
