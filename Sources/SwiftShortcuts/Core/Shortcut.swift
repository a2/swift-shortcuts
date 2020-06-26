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

extension Shortcut {
    public func build() throws -> Data {
        let body = self.body

        let actions: [AnyAction]
        if let decomposable = body as? Decomposable {
            actions = decomposable.decompose()
        } else {
            actions = [AnyAction(body)]
        }

        let actionSteps: [ActionStep.EncodableWrapper] = actions.map { action in
            let mirror = Mirror(reflecting: action)
            let storage = mirror.children[mirror.children.startIndex].value
            let storageMirror = Mirror(reflecting: storage)
            let action = storageMirror.children[storageMirror.children.startIndex].value
            return (action as! ActionStep).encodable()
        }

        let encoder = PropertyListEncoder()
        encoder.outputFormat = .binary
        return try encoder.encode(ShortcutPayload(actions: actionSteps))
    }
}
