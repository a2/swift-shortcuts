enum SerializationType: String, Encodable {
    case arrayParameterState = "WFArrayParameterState"
    case contentPredicateTableTemplate = "WFContentPredicateTableTemplate"
    case dictionaryFieldValue = "WFDictionaryFieldValue"
    case numberSubstitutableState = "WFNumberSubstitutableState"
    case quantityFieldValue = "WFQuantityFieldValue"
    case textTokenAttachment = "WFTextTokenAttachment"
    case textTokenString = "WFTextTokenString"
    case tokenAttachmentParameterState = "WFTokenAttachmentParameterState"
}
