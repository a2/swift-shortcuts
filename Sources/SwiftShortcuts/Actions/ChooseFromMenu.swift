import Foundation

public struct MenuItem {
    let label: String
    let action: AnyShortcut

    public init<Content>(label: String, @ShortcutBuilder action: () -> Content) where Content: Shortcut {
        self.label = label
        self.action = AnyShortcut(action())
    }
}

public struct ChooseFromMenu: Shortcut {
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

    public var body: some Shortcut {
        ShortcutGroup {
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
