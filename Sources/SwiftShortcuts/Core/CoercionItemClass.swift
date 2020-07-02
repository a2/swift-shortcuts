/// Represents available content types that a Variable can be convered to.
public enum CoercionItemClass: Hashable, Encodable {
    /// Anything
    case anything

    /// App Store app
    case appStoreApp

    /// Article
    case article

    /// Boolean
    case boolean

    /// Contact
    case contact

    /// Date
    case date

    /// Dictionary
    case dictionary

    /// Email address
    case emailAddress

    /// File
    case file

    /// Image
    case image

    /// iTunes media
    case iTunesMedia

    /// iTunes product
    case iTunesProduct

    /// Location
    case location

    /// Maps link
    case mapsLink

    /// Media
    case media

    /// Number
    case number

    /// PDF
    case pdf

    /// Phone number
    case phoneNumber

    /// Photo media
    case photoMedia

    /// Place
    case place

    /// Rich text
    case richText

    /// Safari web page
    case safariWebPage

    /// Text
    case text

    /// URL
    case url

    /// vCard
    case vCard

    /// Encodes this value into the given encoder.
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: This function throws an error if any values are invalid for the given encoder's format.
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
            try container.encodeNil() // or do nothing?
        case .url:
            try container.encode("WFURLContentItem")
        case .vCard:
            try container.encode("WFVCardContentItem")
        }
    }
}
