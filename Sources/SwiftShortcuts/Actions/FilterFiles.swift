import Foundation

/// Given a list of files, this action returns the files that match the given criteria.
///
/// **Input:** (Files) The files to filter through
///
/// **Result:** (Files) The files that match the criteria.
public struct FilterFiles: Shortcut {
    let input: Variable
    let filters: FilterSet?
    let sortOrder: SortOrder?
    let limit: Int?

    /// The contents of the shortcut.
    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.filter.files", parameters: Parameters(base: self))
    }

    /// Initializes the shortcut.
    /// - Parameters:
    ///   - input: The files to filter through.
    ///   - filters: A collection of filers to apply to the content.
    ///   - sortOrder: The order to sort the files in.
    ///   - limit: Whether or not to limit the number of files that are passed as output.
    public init(input: Variable, filters: FilterSet? = nil, sortOrder: SortOrder? = nil, limit: Int? = nil) {
        self.input = input
        self.filters = filters
        self.sortOrder = sortOrder
        self.limit = limit
    }
}

/// Represents one or many filter-convertible values that combine to reduce a set of files.
public enum FilterSet {
    /// A file must satisfy each filter in the array.
    case all([FileFilterConvertible])

    /// A file must satisfy any filter in the array.
    case any([FileFilterConvertible])

    /// A file must satisfy a single filter.
    /// - Parameter value: The value to filter on.
    /// - Returns: A filter set with a single value.
    public static func single(_ value: FileFilterConvertible) -> FilterSet { .all([value]) }
}

extension FilterFiles {
    struct Parameters: Encodable {
        enum CodingKeys: String, CodingKey {
            case contentItemFilter = "WFContentItemFilter"
            case input = "WFContentItemInputParameter"
        }

        enum ContentItemFilterCodingKeys: String, CodingKey {
            case value = "Value"
            case serializationType = "WFSerializationType"
        }

        enum ValueCodingKeys: String, CodingKey {
            case limit = "WFContentItemLimitNumber"
            case filters = "WFActionParameterFilterTemplates"
            case filterOperator = "WFActionParameterFilterPrefix"
            case sortOrder = "WFContentItemSortOrder"
            case sortProperty = "WFContentItemSortProperty"
        }

        let base: FilterFiles

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(base.input, forKey: .input)

            var contentItemFilter = container.nestedContainer(keyedBy: ContentItemFilterCodingKeys.self, forKey: .contentItemFilter)
            try contentItemFilter.encode(SerializationType.contentPredicateTableTemplate, forKey: .serializationType)

            var valueContainer = contentItemFilter.nestedContainer(keyedBy: ValueCodingKeys.self, forKey: .value)
            try valueContainer.encodeIfPresent(base.limit, forKey: .limit)

            if let sortOrder = base.sortOrder {
                switch sortOrder {
                case .fileSize(let ascending):
                    try valueContainer.encode(ascending ? "Smallest First" : "Biggest First", forKey: .sortOrder)
                    try valueContainer.encode("File Size", forKey: .sortProperty)
                case .fileExtension(let ascending):
                    try valueContainer.encode(ascending ? "A to Z" : "Z to A", forKey: .sortOrder)
                    try valueContainer.encode("File Extension", forKey: .sortProperty)
                case .creationDate(let ascending):
                    try valueContainer.encode(ascending ? "Oldest First" : "Latest First", forKey: .sortOrder)
                    try valueContainer.encode("Creation Date", forKey: .sortProperty)
                case .lastModifiedDate(let ascending):
                    try valueContainer.encode(ascending ? "Oldest First" : "Latest First", forKey: .sortOrder)
                    try valueContainer.encode("Last Modified Date", forKey: .sortProperty)
                case .name(let ascending):
                    try valueContainer.encode(ascending ? "A to Z" : "Z to A", forKey: .sortOrder)
                    try valueContainer.encode("Name", forKey: .sortProperty)
                case .random:
                    try valueContainer.encode("Random", forKey: .sortOrder)
                }
            }

            if let filters = base.filters {
                switch filters {
                case .all(let filters):
                    try valueContainer.encode(1, forKey: .filterOperator)
                    try valueContainer.encode(filters.map({ $0.fileFilter }), forKey: .filters)
                case .any(let filters):
                    try valueContainer.encode(0, forKey: .filterOperator)
                    try valueContainer.encode(filters.map({ $0.fileFilter }), forKey: .filters)
                }
            }
        }
    }
}

struct TextWrapper: Encodable {
    enum CodingKeys: String, CodingKey {
        case text = "String"
    }

    let text: Text
}

struct DateValues: Encodable {
    enum CodingKeys: String, CodingKey {
        case date = "Date"
        case anotherDate = "AnotherDate"
    }

    let date: VariableValue<Date>
    let anotherDate: VariableValue<Date>?

    init(date: VariableValue<Date>, anotherDate: VariableValue<Date>? = nil) {
        self.date = date
        self.anotherDate = anotherDate
    }
}

// MARK: - Filters

/// A filter that can be applied to a file.
public struct FileFilter: Encodable {
    enum CodingKeys: String, CodingKey {
        case `operator` = "Operator"
        case values = "Values"
        case isRemovable = "Removable"
        case property = "Property"
    }

    let `operator`: ConditionType
    let values: AnyEncodable
    let isRemovable: Bool
    let property: String

    init<Values>(operator: ConditionType, values: Values, isRemovable: Bool, property: String) where Values: Encodable {
        self.operator = `operator`
        self.values = AnyEncodable(values)
        self.isRemovable = isRemovable
        self.property = property
    }

    /// Encodes this value into the given encoder.
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: This function throws an error if any values are invalid for the given encoder's format.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(`operator`, forKey: .`operator`)
        try container.encode(values, forKey: .values)
        try container.encode(isRemovable, forKey: .isRemovable)
        try container.encode(property, forKey: .property)
    }
}

/// The "Name" file-filterable property
public struct NameProperty: FileFilterProperty {
    public typealias Value = Text?

    public static let propertyName = "Name"
}

/// A "Name" file filter
public typealias NameFilter = FileFiltering<NameProperty>

/// The "File Extension" file-filterable property
public struct FileExtensionProperty: FileFilterProperty {
    public typealias Value = Text?

    public static let propertyName = "File Extension"
}

/// A "File Extension" file filter
public typealias FileExtensionFilter = FileFiltering<FileExtensionProperty>

/// The "File Size" file-filterable property
public struct FileSizeProperty: FileFilterProperty {
    public typealias Value = FileSize

    public static let propertyName = "File Size"
}

/// A "File Size" file filter
public typealias FileSizeFilter = FileFiltering<FileSizeProperty>

/// The "Creation Date" file-filterable property
public struct CreationDateProperty: FileFilterProperty {
    public typealias Value = VariableDateValueConvertible

    public static let propertyName = "Creation Date"
}

/// A "Creation Date" file filter
public typealias CreationDateFilter = FileFiltering<CreationDateProperty>

/// The "Last Modified Date" file-filterable property
public struct LastModifiedDateProperty: FileFilterProperty {
    public typealias Value = VariableDateValueConvertible

    public static let propertyName = "Last Modified Date"
}

/// A "Last Modified Date" file filter
public typealias LastModifiedDateFilter = FileFiltering<LastModifiedDateProperty>
