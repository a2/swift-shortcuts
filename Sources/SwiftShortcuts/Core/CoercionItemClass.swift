public enum CoercionItemClass: Hashable, Encodable {
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
            try container.encodeNil() // or do nothing?
        case .url:
            try container.encode("WFURLContentItem")
        case .vCard:
            try container.encode("WFVCardContentItem")
        }
    }
}
