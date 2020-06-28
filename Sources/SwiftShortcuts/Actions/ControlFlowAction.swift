import Foundation

struct ControlFlowAction: Shortcut {
    struct Parameters: Encodable {
        enum CodingKeys: String, CodingKey {
            case groupingIdentifier = "GroupingIdentifier"
            case mode = "WFControlFlowMode"
        }

        let base: ControlFlowAction

        func encode(to encoder: Encoder) throws {
            try base.userInfo?.encode(to: encoder)

            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(base.groupingIdentifier, forKey: .groupingIdentifier)
            try container.encode(base.mode, forKey: .mode)
        }
    }

    enum Mode: Int, Encodable {
        case start
        case middle
        case end
    }

    let identifier: String
    let groupingIdentifier: UUID
    let mode: Mode
    let userInfo: AnyEncodable?

    var body: some Shortcut {
        Action(identifier: identifier, parameters: Parameters(base: self))
    }

    init(identifier: String, groupingIdentifier: UUID, mode: Mode) {
        self.identifier = identifier
        self.groupingIdentifier = groupingIdentifier
        self.mode = mode
        self.userInfo = nil
    }

    init<UserInfo>(identifier: String, groupingIdentifier: UUID, mode: Mode, userInfo: UserInfo) where UserInfo: Encodable {
        self.identifier = identifier
        self.groupingIdentifier = groupingIdentifier
        self.mode = mode
        self.userInfo = AnyEncodable(userInfo)
    }
}
