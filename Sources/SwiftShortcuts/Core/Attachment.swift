import Foundation

struct Attachment: Hashable {
    enum SourceType: Encodable {
        case actionOutput
        case askEachTime
        case clipboard
        case currentDate
        case shortcutInput
        case variable

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
            case .actionOutput:
                try container.encode("ActionOutput")
            case .askEachTime:
                try container.encode("Ask")
            case .clipboard:
                try container.encode("Clipboard")
            case .currentDate:
                try container.encode("CurrentDate")
            case .shortcutInput:
                try container.encode("ExtensionInput")
            case .variable:
                try container.encode("Variable")
            }
        }
    }

    var type: SourceType
    var aggrandizements: [Aggrandizement]?
    var outputName: String?
    var outputUUID: UUID?
    var variableName: String?

    init(type: SourceType, aggrandizements: [Aggrandizement]? = nil, outputName: String? = nil, outputUUID: UUID? = nil, variableName: String? = nil) {
        self.type = type
        self.aggrandizements = aggrandizements
        self.outputName = outputName
        self.outputUUID = outputUUID
        self.variableName = variableName
    }
}

extension Attachment: Encodable {
    enum CodingKeys: String, CodingKey {
        case type = "Type"
        case aggrandizements = "Aggrandizements"
        case outputName = "OutputName"
        case outputUUID = "OutputUUID"
        case variableName = "VariableName"
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(aggrandizements, forKey: .aggrandizements)
        try container.encodeIfPresent(outputName, forKey: .outputName)
        try container.encodeIfPresent(outputUUID, forKey: .outputUUID)
        try container.encodeIfPresent(variableName, forKey: .variableName)
    }
}
