public enum Aggrandizement {
    public enum DateFormatStyle {
        case none(TimeFormatStyle)
        case short(TimeFormatStyle)
        case medium(TimeFormatStyle)
        case long(TimeFormatStyle)
        case rfc2822
        case iso8601(includeTime: Bool)
        case relative(TimeFormatStyle)
        case custom(String)
        case howLongAgoUntil
    }

    public enum TimeFormatStyle: Encodable {
        case none
        case short
        case medium
        case long

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
            case .none:
                try container.encode("None")
            case .short:
                try container.encode("Short")
            case .medium:
                try container.encode("Medium")
            case .long:
                try container.encode("Long")
            }
        }
    }

    public enum CoercionItemClass: Encodable {
        case anything
        case appStoreApp
        case article
        case boolean
        case contact
        case date
        case dictionary
        case emailAddress
        case file
        case image
        case iTunesMedia
        case iTunesProduct
        case location
        case mapsLink
        case media
        case number
        case pdf
        case phoneNumber
        case photoMedia
        case place
        case richText
        case safariWebPage
        case text
        case url
        case vCard

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
            case .anything:
                try container.encode("WFContentItem")
            case .appStoreApp:
                try container.encode("WFAppStoreAppContentItem")
            case .article:
                try container.encode("WFArticleContentItem")
            case .boolean:
                try container.encode("WFBooleanContentItem")
            case .contact:
                try container.encode("WFContactContentItem")
            case .date:
                try container.encode("WFDateContentItem")
            case .dictionary:
                try container.encode("WFDictionaryContentItem")
            case .emailAddress:
                try container.encode("WFEmailAddressContentItem")
            case .file:
                try container.encode("WFGenericFileContentItem")
            case .image:
                try container.encode("WFImageContentItem")
            case .iTunesMedia:
                try container.encode("WFMPMediaContentItem")
            case .iTunesProduct:
                try container.encode("WFiTunesProductContentItem")
            case .location:
                try container.encode("WFLocationContentItem")
            case .mapsLink:
                try container.encode("WFDCMapsLinkContentItem")
            case .media:
                try container.encode("WFAVAssetContentItem")
            case .number:
                try container.encode("WFNumberContentItem")
            case .pdf:
                try container.encode("WFPDFContentItem")
            case .phoneNumber:
                try container.encode("WFPhoneNumberContentItem")
            case .photoMedia:
                try container.encode("WFPhotoMediaContentItem")
            case .place:
                try container.encode("WFMKMapItemContentItem")
            case .richText:
                try container.encode("WFRichTextContentItem")
            case .safariWebPage:
                try container.encode("WFSafariWebPageContentItem")
            case .text:
                try container.encodeNil()
            case .url:
                try container.encode("WFURLContentItem")
            case .vCard:
                try container.encode("WFVCardContentItem")
            }
        }
    }

    public struct PropertyName: RawRepresentable, Encodable {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public init(_ rawValue: String) {
            self.rawValue = rawValue
        }

        public static var fileSize: PropertyName { PropertyName("File Size") }
        public static var fileExtension: PropertyName { PropertyName("File Extension") }
        public static var name: PropertyName { PropertyName("Name") }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(rawValue)
        }
    }

    public enum PropertyUserInfo: Encodable {
        case fileSize
        case fileExtension
        case number(Number)

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
            case .fileSize:
                try container.encode("WFFileSizeProperty")
            case .fileExtension:
                try container.encode("WFFileExtensionProperty")
            case .number(let number):
                try container.encode(number)
            }
        }
    }

    case coercion(class: CoercionItemClass)
    case dateFormat(DateFormatStyle)
    case dictionaryValue(key: String?)
    case property(name: PropertyName, userInfo: PropertyUserInfo)
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

    public func encode(to encoder: Encoder) throws {
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
            try container.encode(userInfo, forKey: .userInfo)
        }
    }
}
