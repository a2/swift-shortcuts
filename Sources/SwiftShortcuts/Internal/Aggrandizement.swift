enum Aggrandizement: Hashable {
    case coercion(class: CoercionItemClass)
    case dateFormat(DateFormatStyle)
    case dictionaryValue(key: String?)
    case property(name: PropertyName, userInfo: PropertyUserInfo? = nil)
}

extension Aggrandizement: Encodable {
    enum AggrandizementType: String, Encodable {
        case coercion = "WFCoercionVariableAggrandizement"
        case dateFormat = "WFDateFormatVariableAggrandizement"
        case dictionaryValue = "WFDictionaryValueVariableAggrandizement"
        case property = "WFPropertyVariableAggrandizement"
    }

    enum CoercionCodingKeys: String, CodingKey {
        case type = "Type"
        case coercionClass = "CoercionItemClass"
    }

    enum DateFormatCodingKeys: String, CodingKey {
        case type = "Type"
        case dateFormatStyle = "WFDateFormatStyle"
        case timeFormatStyle = "WFTimeFormatStyle"
        case relativeDateFormatStyle = "WFRelativeDateFormatStyle"
        case iso8601IncludeTime = "WFISO8601IncludeTime"
        case dateFormat = "WFDateFormat"
    }

    enum DateFormatStyleName: String, Encodable {
        case none = "None"
        case short = "Short"
        case medium = "Medium"
        case long = "Long"
        case rfc2822 = "RFC 2822"
        case iso8601 = "ISO 8601"
        case relative = "Relative"
        case custom = "Custom"
    }

    enum DictionaryValueCodingKeys: String, CodingKey {
        case type = "Type"
        case key = "DictionaryKey"
    }

    enum PropertyCodingKeys: String, CodingKey {
        case type = "Type"
        case name = "PropertyName"
        case userInfo = "PropertyUserInfo"
    }

    func encode(to encoder: Encoder) throws {
        switch self {
        case .coercion(let coercionClass):
            var container = encoder.container(keyedBy: CoercionCodingKeys.self)
            try container.encode(AggrandizementType.coercion, forKey: .type)
            try container.encode(coercionClass, forKey: .coercionClass)
        case .dateFormat(let format):
            var container = encoder.container(keyedBy: DateFormatCodingKeys.self)

            switch format {
            case .none(let timeFormatStyle):
                try container.encode(DateFormatStyleName.none, forKey: .dateFormatStyle)
                try container.encode(timeFormatStyle, forKey: .timeFormatStyle)
            case .short(let timeFormatStyle):
                try container.encode(DateFormatStyleName.short, forKey: .dateFormatStyle)
                try container.encode(timeFormatStyle, forKey: .timeFormatStyle)
            case .medium(let timeFormatStyle):
                try container.encode(DateFormatStyleName.medium, forKey: .dateFormatStyle)
                try container.encode(timeFormatStyle, forKey: .timeFormatStyle)
            case .long(let timeFormatStyle):
                try container.encode(DateFormatStyleName.long, forKey: .dateFormatStyle)
                try container.encode(timeFormatStyle, forKey: .timeFormatStyle)
            case .rfc2822:
                try container.encode(DateFormatStyleName.rfc2822, forKey: .dateFormatStyle)
            case .iso8601(let includeTime):
                try container.encode(DateFormatStyleName.iso8601, forKey: .dateFormatStyle)
                try container.encode(includeTime, forKey: .iso8601IncludeTime)
            case .relative(let timeFormatStyle):
                try container.encode(DateFormatStyleName.relative, forKey: .dateFormatStyle)
                try container.encode(timeFormatStyle, forKey: .timeFormatStyle)
                try container.encode(DateFormatStyleName.short, forKey: .relativeDateFormatStyle)
            case .custom(let dateFormat):
                try container.encode(DateFormatStyleName.custom, forKey: .dateFormatStyle)
                try container.encode(dateFormat, forKey: .dateFormat)
            case .howLongAgoUntil:
                try container.encode(DateFormatStyleName.relative, forKey: .dateFormatStyle)
            }
        case .dictionaryValue(let key):
            var container = encoder.container(keyedBy: DictionaryValueCodingKeys.self)
            try container.encode(AggrandizementType.dictionaryValue, forKey: .type)
            try container.encodeIfPresent(key, forKey: .key)
        case .property(let name, let userInfo):
            var container = encoder.container(keyedBy: PropertyCodingKeys.self)
            try container.encode(AggrandizementType.property, forKey: .type)
            try container.encode(name, forKey: .name)
            try container.encodeIfPresent(userInfo, forKey: .userInfo)
        }
    }
}
