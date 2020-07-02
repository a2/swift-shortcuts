/// An HTTP method used by `GetContentsOfURL`.
public enum HTTPMethod: String, Encodable {
    /// Represents a GET request. Request bodies are not supported.
    case GET = "GET"

    /// Represents a POST request.
    case POST = "POST"

    /// Represents a PUT request.
    case PUT = "PUT"

    /// Represents a PATCH request.
    case PATCH = "PATCH"

    /// Represents a DELETE request.
    case DELETE = "DELETE"
}

/// The data sent as the message body of a request, such as for an HTTP POST request.
/// - See Also: `GetContentsOfURL`
public enum RequestBody {
    /// A JSON request body.
    ///
    /// - Attention: `null` values are not supported by the Shortcuts app.
    case json([(key: Text, value: DictionaryValue)])

    /// A multipart form request body.
    case form([(key: Text, value: MultipartFormValue)])

    /// A raw data payload.
    case file(Variable)

    // MARK: - Convenience Constructors
    
    /// This convenience constructor converts the ordered KeyValuePairs collection into an Array of tuples.
    /// - Parameter payload: The payload of the request body, expressed as a dictionary literal.
    /// - Returns: A JSON request body.
    public static func json(_ payload: KeyValuePairs<Text, DictionaryValue>) -> RequestBody {
        .json(Array(payload))
    }

    /// This convenience constructor converts the ordered KeyValuePairs collection into an Array of tuples.
    /// - Parameter payload: The payload of the request body, expressed as a dictionary literal.
    /// - Returns: A multipart form request body.
    public static func form(_ payload: KeyValuePairs<Text, MultipartFormValue>) -> RequestBody {
        .form(Array(payload))
    }
}

/// Gets the contents of URLs passed into the action. Useful for downloading files and web content, or for making API requests.
///
/// **Input:** URLs
///
/// **Result:** (Files) The fetched data
public struct GetContentsOfURL: Shortcut {
    let method: VariableValue<HTTPMethod>
    let url: Text
    let headers: [(key: Text, value: Text)]
    let requestBody: RequestBody?

    /// The contents of the shortcut.
    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.downloadurl", parameters: Parameters(base: self))
    }

    /// Initializes the shortcut.
    /// - Parameters:
    ///   - method: The HTTP method to use, or a Variable representing one.
    ///   - url: The URL to fetch.
    ///   - headers: Custom request headers to send, if any.
    ///   - body: The requset body. Unsupposed for GET requests.
    public init(method: VariableValue<HTTPMethod>, url: Text, headers: KeyValuePairs<Text, Text> = [:], body: RequestBody?) {
        self.method = method
        self.url = url
        self.headers = Array(headers)
        self.requestBody = body
    }

    /// Initializes the shortcut.
    /// - Parameters:
    ///   - method: The HTTP method to use.
    ///   - url: The URL to fetch.
    ///   - headers: Custom request headers to send, if any.
    ///   - body: The requset body. Unsupposed for GET requests.
    public init(method: HTTPMethod, url: Text, headers: KeyValuePairs<Text, Text> = [:], body: RequestBody?) {
        self.init(method: .value(method), url: url, headers: headers, body: body)
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
