import Foundation

public protocol Shortcut {
    associatedtype Body: Action

    var body: Body { get }

    func build() throws -> Data
}

struct ShortcutPayload: Encodable {
    struct Icon: Encodable {
        enum CodingKeys: String, CodingKey {
            case startColor = "WFWorkflowIconStartColor"
            case glyphNumber = "WFWorkflowIconGlyphNumber"
            case imageData = "WFWorkflowIconImageData"
        }

        let startColor: Number
        let imageData: Data?
        let glyphNumber: Number
    }

    enum CodingKeys: String, CodingKey {
        case clientVersion = "WFWorkflowClientVersion"
        case minimumClientVersion = "WFWorkflowMinimumClientVersion"
        case minimumClientVersionString = "WFWorkflowMinimumClientVersionString"
        case workflowTypes = "WFWorkflowTypes"
        case icon = "WFWorkflowIcon"
        case inputContentItemClasses = "WFWorkflowInputContentItemClasses"
        case actions = "WFWorkflowActions"
    }

    let clientVersion = "1080.4"
    let minimumClientVersion: Number = 900
    let minimumClientVersionString = "900"
    let workflowTypes = ["WatchKit", "NCWidget"]
    let icon = Icon(startColor: 0xFF4351FF, imageData: nil, glyphNumber: 0xE877)
    let inputContentItemClasses = [
        "WFAppStoreAppContentItem",
        "WFArticleContentItem",
        "WFContactContentItem",
        "WFDateContentItem",
        "WFEmailAddressContentItem",
        "WFGenericFileContentItem",
        "WFImageContentItem",
        "WFiTunesProductContentItem",
        "WFLocationContentItem",
        "WFDCMapsLinkContentItem",
        "WFAVAssetContentItem",
        "WFPDFContentItem",
        "WFPhoneNumberContentItem",
        "WFRichTextContentItem",
        "WFSafariWebPageContentItem",
        "WFStringContentItem",
        "WFURLContentItem",
    ]
    let actions: [ActionStep.EncodableWrapper]
}

extension AnyAction {
    var actionStep: ActionStep? {
        (storage as? AnyActionStorage<ActionStep>)?.action
    }
}

extension Shortcut {
    func encodableActionSteps() -> [ActionStep.EncodableWrapper] {
        let decomposed = body.decompose()
        return decomposed.map { actionStep in actionStep.encodable() }
    }

    public func build() throws -> Data {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .binary
        return try encoder.encode(ShortcutPayload(actions: encodableActionSteps()))
    }
}
