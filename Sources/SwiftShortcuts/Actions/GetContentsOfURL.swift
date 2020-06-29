public enum HTTPMethod: Encodable {
    case GET
    case POST
    case PUT
    case PATCH
    case DELETE
    case askEachTime

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .GET:
            try container.encode("GET")
        case .POST:
            try container.encode("POST")
        case .PUT:
            try container.encode("PUT")
        case .PATCH:
            try container.encode("PATCH")
        case .DELETE:
            try container.encode("DELETE")
        case .askEachTime:
            try container.encode(Variable.askEachTime)
        }
    }
}

public enum RequestBody {
    case json([(key: InterpolatedText, value: DictionaryValue)])
    case form([(key: InterpolatedText, value: DictionaryValue)]) // FIXME: key = Interpolatedtext, value: InterpolatedText | File
    case file(Variable)

    public static func json(_ payload: KeyValuePairs<InterpolatedText, DictionaryValue>) -> RequestBody {
        .json(Array(payload))
    }

    public static func form(_ payload: KeyValuePairs<InterpolatedText, DictionaryValue>) -> RequestBody {
        .form(Array(payload))
    }
}

public struct GetContentsOfURL: Shortcut {
    let method: HTTPMethod
    let url: InterpolatedText
    let headers: [(key: InterpolatedText, value: InterpolatedText)]
    let requestBody: RequestBody?

    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.downloadurl", parameters: Parameters(base: self))
    }

    public init(method: HTTPMethod, url: InterpolatedText, headers: KeyValuePairs<InterpolatedText, InterpolatedText> = [:], body: RequestBody?) {
        self.method = method
        self.url = url
        self.headers = Array(headers)
        self.requestBody = body
    }
}

extension GetContentsOfURL {
    struct Parameters: Encodable {
        enum CodingKeys: String, CodingKey {
            case url = "WFURL"
            case httpMethod = "WFHTTPMethod"
            case bodyType = "WFHTTPBodyType"
            case jsonValues = "WFJSONValues"
            case formValues = "WFFormValues"
            case requestVariable = "WFRequestVariable"
            case headers = "WFHTTPHeaders"
        }

        enum BodyType: String, Encodable {
            case json = "JSON"
            case form = "Form"
            case file = "File"
        }

        let base: GetContentsOfURL

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(base.url, forKey: .url)
            try container.encode(base.method, forKey: .httpMethod)

            let headers = base.headers.map { key, value in (key, DictionaryValue.string(value)) }
            try container.encode(DictionaryValue.dictionary(headers), forKey: .headers)

            if let requestBody = base.requestBody {
                switch requestBody {
                case .json(let dictionary):
                    try container.encode(BodyType.json, forKey: .bodyType)
                    try container.encode(OuterDictionary(dictionary: dictionary), forKey: .jsonValues)
                case .form(let dictionary):
                    try container.encode(BodyType.form, forKey: .bodyType)
                    try container.encode(OuterDictionary(dictionary: dictionary), forKey: .formValues)
                case .file(let variable):
                    try container.encode(BodyType.file, forKey: .bodyType)
                    try container.encode(variable, forKey: .requestVariable)
                }
            }
        }
    }
}
