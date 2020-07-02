/// Represents a property that can be used to filter a collection of files.
public protocol FileFilterProperty {
    /// The type of value that such a property represents.
    associatedtype Value

    /// The name of the property as used in the Shortcuts app.
    static var propertyName: String { get }
}

/// A value that can be converted to a `FileFilter`.
public protocol FileFilterConvertible {
    /// The inner `FileFilter` represented by this value.
    var fileFilter: FileFilter { get }
}

/// Represents a `FileFilterConvertible` value by means of a property on such a file.
public struct FileFiltering<Property>: FileFilterConvertible where Property: FileFilterProperty {
    /// The inner `FileFilter` represented by this value.
    public let fileFilter: FileFilter

    /// This initializer is internal to enforce type safety.
    init(fileFilter: FileFilter) {
        self.fileFilter = fileFilter
    }
}

extension FileFiltering where Property.Value == Text? {
    /// Initializes the value with a filter that keeps files whose property is equal to the text argument.
    /// - Parameter text: The text to compare.
    public init(is text: Text?) {
        let values = TextWrapper(text: text ?? "")
        self.fileFilter = FileFilter(operator: .is, values: values, isRemovable: true, property: Property.propertyName)
    }

    /// Initializes the value with a filter that keeps files whose property is not equal to the text argument.
    /// - Parameter text: The text to compare.
    public init(isNot text: Text?) {
        let values = TextWrapper(text: text ?? "")
        self.fileFilter = FileFilter(operator: .isNot, values: values, isRemovable: true, property: Property.propertyName)
    }

    /// Initializes the value with a filter that keeps files whose property contains the text argument.
    /// - Parameter text: The text to compare.
    public init(contains text: Text?) {
        let values = TextWrapper(text: text ?? "")
        self.fileFilter = FileFilter(operator: .contains, values: values, isRemovable: true, property: Property.propertyName)
    }

    /// Initializes the value with a filter that keeps files whose property does not contain the text argument.
    /// - Parameter text: The text to compare.
    public init(doesNotContain text: Text?) {
        let values = TextWrapper(text: text ?? "")
        self.fileFilter = FileFilter(operator: .doesNotContain, values: values, isRemovable: true, property: Property.propertyName)
    }

    /// Initializes the value with a filter that keeps files whose property begins with the text argument.
    /// - Parameter text: The text to compare.
    public init(beginsWith text: Text?) {
        let values = TextWrapper(text: text ?? "")
        self.fileFilter = FileFilter(operator: .beginsWith, values: values, isRemovable: true, property: Property.propertyName)
    }

    /// Initializes the value with a filter that keeps files whose property ends with the text argument.
    /// - Parameter text: The text to compare.
    public init(endsWith text: Text?) {
        let values = TextWrapper(text: text ?? "")
        self.fileFilter = FileFilter(operator: .endsWith, values: values, isRemovable: true, property: Property.propertyName)
    }
}

extension FileFiltering where Property.Value == FileSize {
    /// Initializes the value with a filter that keeps files whose property is equal to the file size argument.
    /// - Parameter fileSize: The file size to compare.
    public init(isExactly fileSize: FileSize) {
        self.fileFilter = FileFilter(operator: .is, values: fileSize, isRemovable: true, property: Property.propertyName)
    }

    /// Initializes the value with a filter that keeps files whose property is not equal to the file size argument.
    /// - Parameter fileSize: The file size to compare.
    public init(isNotExactly fileSize: FileSize) {
        self.fileFilter = FileFilter(operator: .isNot, values: fileSize, isRemovable: true, property: Property.propertyName)
    }

    /// Initializes the value with a filter that keeps files whose property is larger than the file size argument.
    /// - Parameter fileSize: The file size to compare.
    public init(isLargerThan fileSize: FileSize) {
        self.fileFilter = FileFilter(operator: .isGreaterThan, values: fileSize, isRemovable: true, property: Property.propertyName)
    }

    /// Initializes the value with a filter that keeps files whose property is larger than or equal to the file size argument.
    /// - Parameter fileSize: The file size to compare.
    public init(isLargerThanOrEqualTo fileSize: FileSize) {
        self.fileFilter = FileFilter(operator: .isGreaterThanOrEqualTo, values: fileSize, isRemovable: true, property: Property.propertyName)
    }

    /// Initializes the value with a filter that keeps files whose property is smaller than the file size argument.
    /// - Parameter fileSize: The file size to compare.
    public init(isSmallerThan fileSize: FileSize) {
        self.fileFilter = FileFilter(operator: .isLessThan, values: fileSize, isRemovable: true, property: Property.propertyName)
    }

    /// Initializes the value with a filter that keeps files whose property is smaller than or equal to the file size argument.
    /// - Parameter fileSize: The file size to compare.
    public init(isSmallerThanOrEqualTo fileSize: FileSize) {
        self.fileFilter = FileFilter(operator: .isLessThanOrEqualTo, values: fileSize, isRemovable: true, property: Property.propertyName)
    }
}

extension FileFiltering where Property.Value == VariableDateValueConvertible {
    /// Initializes the value with a filter that keeps files whose property is equal to the date or variable argument.
    /// - Parameter value: The date or variable to compare.
    public init(isExactly value: VariableDateValueConvertible) {
        self.fileFilter = FileFilter(operator: .is, values: DateValues(date: value.variableDateValue), isRemovable: true, property: Property.propertyName)
    }

    /// Initializes the value with a filter that keeps files whose property is not equal to the date or variable argument.
    /// - Parameter value: The date or variable to compare.
    public init(isNotExactly value: VariableDateValueConvertible) {
        self.fileFilter = FileFilter(operator: .isNot, values: DateValues(date: value.variableDateValue), isRemovable: true, property: Property.propertyName)
    }

    /// Initializes the value with a filter that keeps files whose property is after the date or variable argument.
    /// - Parameter value: The date or variable to compare.
    public init(isAfter value: VariableDateValueConvertible) {
        self.fileFilter = FileFilter(operator: .isGreaterThan, values: DateValues(date: value.variableDateValue), isRemovable: true, property: Property.propertyName)
    }

    /// Initializes the value with a filter that keeps files whose property is before the date or variable argument.
    /// - Parameter value: The date or variable to compare.
    public init(isBefore value: VariableDateValueConvertible) {
        self.fileFilter = FileFilter(operator: .isLessThan, values: DateValues(date: value.variableDateValue), isRemovable: true, property: Property.propertyName)
    }

    /// Initializes the value with a filter that keeps files whose property is today.
    public static var isToday: Self {
        Self(fileFilter: FileFilter(operator: .isToday, values: EmptyParameters(), isRemovable: true, property: Property.propertyName))
    }

    /// Initializes the value with a filter that keeps files whose property is between the dates or variable arguments.
    /// - Parameters:
    ///   - startValue: A date or variable to compare.
    ///   - endValue: A date or variable to compare.
    public init(isBetween startValue: VariableDateValueConvertible, and endValue: VariableDateValueConvertible) {
        self.fileFilter = FileFilter(operator: .isBetween, values: DateValues(date: startValue.variableDateValue, anotherDate: endValue.variableDateValue), isRemovable: true, property: Property.propertyName)
    }

    /// Initializes the value with a filter that keeps files whose property is in the time period represented by the time span argument.
    /// - Parameter timeSpan: A time span to compare.
    public init(isInTheLast timeSpan: TimeSpanValue) {
        self.fileFilter = FileFilter(operator: .isInTheLast, values: timeSpan, isRemovable: true, property: Property.propertyName)
    }
}
