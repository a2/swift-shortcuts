import Foundation

/// A menu item as displayed in `ChooseFromMenu`.
public struct MenuItem {
    let label: String
    let shortcut: AnyShortcut

    /// Initializes the shortcut.
    /// - Parameters:
    ///   - label: The text context to display in the menu.
    ///   - shortcut: The shortcut to run when selected.
    public init<Content>(label: String, @ShortcutBuilder shortcut: () -> Content) where Content: Shortcut {
        self.label = label
        self.shortcut = AnyShortcut(shortcut())
    }
}

/// Presents a menu and runs different actions based on which menu item was chosen.
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

    /// The contents of the shortcut.
    public var body: some Shortcut {
        ShortcutGroup {
            ControlFlowAction(identifier: identifier, groupingIdentifier: groupingIdentifier, mode: .start, userInfo: StartUserInfo(prompt: prompt, menuItems: items.map({ $0.label })))

            ForEach(items) { item in
                ControlFlowAction(identifier: identifier, groupingIdentifier: groupingIdentifier, mode: .middle, userInfo: MiddleUserInfo(menuItemTitle: item.label))
                item.shortcut
            }

            ControlFlowAction(identifier: identifier, groupingIdentifier: groupingIdentifier, mode: .end)
        }
    }

    let prompt: String
    let items: [MenuItem]
    let groupingIdentifier: UUID

    /// Initializes the shortcut.
    /// - Parameters:
    ///   - prompt: The instruction provided when the menu is presented.
    ///   - groupingIdentifier: An optional UUID, useful for building deterministic output.
    ///   - items: The menu items that the user can choose from.
    public init(prompt: String = "", groupingIdentifier: UUID = UUID(), items: [MenuItem]) {
        self.prompt = prompt
        self.items = items
        self.groupingIdentifier = groupingIdentifier
    }
}
