import Foundation

public struct FilterFiles: Shortcut {
    let input: Variable
    let filters: FilterSet?
    let sortOrder: SortOrder?
    let limit: Int?

    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.filter.files", parameters: Parameters(base: self))
    }

    public init(input: Variable, filters: FilterSet? = nil, sortOrder: SortOrder? = nil, limit: Int? = nil) {
        self.input = input
        self.filters = filters
        self.sortOrder = sortOrder
        self.limit = limit
    }
}

public enum FilterSet {
    case one(FileFilterConvertible)
    case all([FileFilterConvertible])
    case any([FileFilterConvertible])
}

extension FilterFiles {
    struct Parameters: Encodable {
        enum CodingKeys: String, CodingKey {
            case contentItemFilter = "WFContentItemFilter"
            case input = "WFContentItemInputParameter"
        }

        enum SerializationType: String, Encodable {
            case contentPredicateTableTemplate = "WFContentPredicateTableTemplate"
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
            case boundedDate = "WFContentPredicateBoundedDate" // ?
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
                case .one(let filter):
                    try valueContainer.encode(1, forKey: .filterOperator)
                    try valueContainer.encode([filter.fileFilter], forKey: .filters)
                case .all(let filters):
                    try valueContainer.encode(1, forKey: .filterOperator)
                    try valueContainer.encode(filters.map(\.fileFilter), forKey: .filters)
                case .any(let filters):
                    try valueContainer.encode(0, forKey: .filterOperator)
                    try valueContainer.encode(filters.map(\.fileFilter), forKey: .filters)
                }
            }
        }
    }
}

// MARK: - Sort Order

public enum SortOrder: Encodable {
    enum CodingKeys: String, CodingKey {
        case sortOrder = "WFContentItemSortOrder"
        case sortProperty = "WFContentItemSortProperty"
    }

    case fileSize(ascending: Bool)
    case fileExtension(ascending: Bool)
    case creationDate(ascending: Bool)
    case lastModifiedDate(ascending: Bool)
    case name(ascending: Bool)
    case random

    public func encode(to encoder: Encoder) throws {
        var nestedContainer = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .fileSize(let ascending):
            try nestedContainer.encode(ascending ? "Smallest First" : "Biggest First", forKey: .sortOrder)
            try nestedContainer.encode("File Size", forKey: .sortProperty)
        case .fileExtension(let ascending):
            try nestedContainer.encode(ascending ? "A to Z" : "Z to A", forKey: .sortOrder)
            try nestedContainer.encode("File Extension", forKey: .sortProperty)
        case .creationDate(let ascending):
            try nestedContainer.encode(ascending ? "Oldest First" : "Latest First", forKey: .sortOrder)
            try nestedContainer.encode("Creation Date", forKey: .sortProperty)
        case .lastModifiedDate(let ascending):
            try nestedContainer.encode(ascending ? "Oldest First" : "Latest First", forKey: .sortOrder)
            try nestedContainer.encode("Last Modified Date", forKey: .sortProperty)
        case .name(let ascending):
            try nestedContainer.encode(ascending ? "A to Z" : "Z to A", forKey: .sortOrder)
            try nestedContainer.encode("Name", forKey: .sortProperty)
        case .random:
            try nestedContainer.encode("Random", forKey: .sortOrder)
        }
    }
}

// MARK: - Data Types

enum UnitType: Int, Encodable {
    case bytes = 4
}

public enum ByteCountUnit: Encodable {
    case bytes
    case KB
    case MB
    case GB
    case TB
    case PB
    case EB
    case ZB
    case askEachTime

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .bytes:
            try container.encode(1)
        case .KB:
            try container.encode(2)
        case .MB:
            try container.encode(4)
        case .GB:
            try container.encode(8)
        case .TB:
            try container.encode(16)
        case .PB:
            try container.encode(32)
        case .EB:
            try container.encode(64)
        case .ZB:
            try container.encode(128)
        case .askEachTime:
            try container.encode(Variable.askEachTime)
        }
    }
}

public struct FileSize: Encodable {
    enum CodingKeys: String, CodingKey {
        case unitType = "Unit"
        case number = "Number"
        case unit = "ByteCountUnit"
    }

    public var number: InterpolatedText?
    public var unit: ByteCountUnit

    public init(number: InterpolatedText?, unit: ByteCountUnit) {
        self.number = number
        self.unit = unit
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(number ?? "", forKey: .number)
        try container.encode(unit, forKey: .unit)
        try container.encode(UnitType.bytes, forKey: .unitType)
    }
}

struct InterpolatedTextWrapper: Encodable {
    enum CodingKeys: String, CodingKey {
        case text = "String"
    }

    let text: InterpolatedText
}

public enum DateFilterValue: Encodable {
    case date(Date)
    case variable(Variable)

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .date(let date):
            try container.encode(date)
        case .variable(let variable):
            try container.encode(variable)
        }
    }
}

public protocol DateFilterValueConvertible {
    var dateFilterValue: DateFilterValue { get }
}

extension Date: DateFilterValueConvertible {
    public var dateFilterValue: DateFilterValue { .date(self) }
}

extension Variable: DateFilterValueConvertible {
    public var dateFilterValue: DateFilterValue { .variable(self) }
}

struct DateValues: Encodable {
    enum CodingKeys: String, CodingKey {
        case date = "Date"
        case anotherDate = "AnotherDate"
    }

    let date: DateFilterValue
    let anotherDate: DateFilterValue?

    init(date: DateFilterValue, anotherDate: DateFilterValue? = nil) {
        self.date = date
        self.anotherDate = anotherDate
    }
}

public enum TimeUnit: Encodable {
    case years
    case months
    case weeks
    case days
    case hours
    case minutes
    case seconds
    case askEachTime

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .years:
            try container.encode(4)
        case .months:
            try container.encode(8)
        case .weeks:
            try container.encode(8192)
        case .days:
            try container.encode(16)
        case .hours:
            try container.encode(32)
        case .minutes:
            try container.encode(64)
        case .seconds:
            try container.encode(128)
        case .askEachTime:
            try container.encode(Variable.askEachTime)
        }
    }
}

public struct TimeSpanValue: Encodable {
    enum CodingKeys: String, CodingKey {
        case number = "Number"
        case unit = "Unit"
    }

    public var number: InterpolatedText?
    public var unit: TimeUnit

    public init(number: InterpolatedText?, unit: TimeUnit) {
        self.number = number
        self.unit = unit
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(number ?? "", forKey: .number)
        try container.encode(unit, forKey: .unit)
    }
}

// MARK: - Filters

public struct FileFilter: Encodable {
    enum CodingKeys: String, CodingKey {
        case `operator` = "Operator"
        case values = "Values"
        case isRemovable = "Removable"
        case property = "Property"
    }

    let `operator`: Int
    let values: AnyEncodable
    let isRemovable: Bool
    let property: String

    init<Values>(operator: Int, values: Values, isRemovable: Bool, property: String) where Values: Encodable {
        self.operator = `operator`
        self.values = AnyEncodable(values)
        self.isRemovable = isRemovable
        self.property = property
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(`operator`, forKey: .`operator`)
        try container.encode(values, forKey: .values)
        try container.encode(isRemovable, forKey: .isRemovable)
        try container.encode(property, forKey: .property)
    }
}

public protocol FileFilterProperty {
    associatedtype Value
    static var propertyName: String { get }
}

public protocol FileFilterConvertible {
    var fileFilter: FileFilter { get }
}

public struct FileFiltering<Property>: FileFilterConvertible where Property: FileFilterProperty {
    public let fileFilter: FileFilter

    init(fileFilter: FileFilter) {
        self.fileFilter = fileFilter
    }
}

extension FileFiltering where Property.Value == InterpolatedText? {
    public init(is text: InterpolatedText?) {
        let values = InterpolatedTextWrapper(text: text ?? "")
        self.fileFilter = FileFilter(operator: 4, values: values, isRemovable: true, property: Property.propertyName)
    }

    public init(isNot text: InterpolatedText?) {
        let values = InterpolatedTextWrapper(text: text ?? "")
        self.fileFilter = FileFilter(operator: 5, values: values, isRemovable: true, property: Property.propertyName)
    }

    public init(contains text: InterpolatedText?) {
        let values = InterpolatedTextWrapper(text: text ?? "")
        self.fileFilter = FileFilter(operator: 99, values: values, isRemovable: true, property: Property.propertyName)
    }

    public init(doesNotContain text: InterpolatedText?) {
        let values = InterpolatedTextWrapper(text: text ?? "")
        self.fileFilter = FileFilter(operator: 999, values: values, isRemovable: true, property: Property.propertyName)
    }

    public init(beginsWith text: InterpolatedText?) {
        let values = InterpolatedTextWrapper(text: text ?? "")
        self.fileFilter = FileFilter(operator: 8, values: values, isRemovable: true, property: Property.propertyName)
    }

    public init(endsWith text: InterpolatedText?) {
        let values = InterpolatedTextWrapper(text: text ?? "")
        self.fileFilter = FileFilter(operator: 9, values: values, isRemovable: true, property: Property.propertyName)
    }
}

extension FileFiltering where Property.Value == FileSize {
    public init(isExactly fileSize: FileSize) {
        self.fileFilter = FileFilter(operator: 4, values: fileSize, isRemovable: true, property: Property.propertyName)
    }

    public init(isNotExactly fileSize: FileSize) {
        self.fileFilter = FileFilter(operator: 5, values: fileSize, isRemovable: true, property: Property.propertyName)
    }

    public init(isLargerThan fileSize: FileSize) {
        self.fileFilter = FileFilter(operator: 2, values: fileSize, isRemovable: true, property: Property.propertyName)
    }

    public init(isLargerThanOrEqualTo fileSize: FileSize) {
        self.fileFilter = FileFilter(operator: 3, values: fileSize, isRemovable: true, property: Property.propertyName)
    }

    public init(isSmallerThan fileSize: FileSize) {
        self.fileFilter = FileFilter(operator: 0, values: fileSize, isRemovable: true, property: Property.propertyName)
    }

    public init(isSmallerThanOrEqualTo fileSize: FileSize) {
        self.fileFilter = FileFilter(operator: 1, values: fileSize, isRemovable: true, property: Property.propertyName)
    }
}

extension FileFiltering where Property.Value == DateFilterValueConvertible {
    public init(isExactly value: DateFilterValueConvertible) {
        self.fileFilter = FileFilter(operator: 4, values: DateValues(date: value.dateFilterValue), isRemovable: true, property: Property.propertyName)
    }

    public init(isNotExactly value: DateFilterValueConvertible) {
        self.fileFilter = FileFilter(operator: 5, values: DateValues(date: value.dateFilterValue), isRemovable: true, property: Property.propertyName)
    }

    public init(isAfter value: DateFilterValueConvertible) {
        self.fileFilter = FileFilter(operator: 2, values: DateValues(date: value.dateFilterValue), isRemovable: true, property: Property.propertyName)
    }

    public init(isBefore value: DateFilterValueConvertible) {
        self.fileFilter = FileFilter(operator: 0, values: DateValues(date: value.dateFilterValue), isRemovable: true, property: Property.propertyName)
    }

    public static var isToday: Self {
        Self(fileFilter: FileFilter(operator: 1002, values: EmptyParameters(), isRemovable: true, property: Property.propertyName))
    }

    public init(isBetween startValue: DateFilterValueConvertible, and endValue: DateFilterValueConvertible) {
        self.fileFilter = FileFilter(operator: 1003, values: DateValues(date: startValue.dateFilterValue, anotherDate: endValue.dateFilterValue), isRemovable: true, property: Property.propertyName)
    }

    public init(isInTheLast timeSpan: TimeSpanValue) {
        self.fileFilter = FileFilter(operator: 1001, values: timeSpan, isRemovable: true, property: Property.propertyName)
    }
}

public struct NameProperty: FileFilterProperty {
    public typealias Value = InterpolatedText?
    public static let propertyName = "Name"
}

public typealias NameFilter = FileFiltering<NameProperty>

public struct FileExtensionProperty: FileFilterProperty {
    public typealias Value = InterpolatedText?
    public static let propertyName = "File Extension"
}

public typealias FileExtensionFilter = FileFiltering<FileExtensionProperty>

public struct FileSizeProperty: FileFilterProperty {
    public typealias Value = FileSize
    public static let propertyName = "File Size"
}

public typealias FileSizeFilter = FileFiltering<FileSizeProperty>

public struct CreationDateProperty: FileFilterProperty {
    public typealias Value = DateFilterValueConvertible
    public static let propertyName = "Creation Date"
}

public typealias CreationDateFilter = FileFiltering<CreationDateProperty>

public struct LastModifiedDateProperty: FileFilterProperty {
    public typealias Value = DateFilterValueConvertible
    public static let propertyName = "Last Modified Date"
}

public typealias LastModifiedDateFilter = FileFiltering<LastModifiedDateProperty>
