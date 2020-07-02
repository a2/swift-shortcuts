/// A set of predefined date format styles.
public enum DateFormatStyle: Hashable {
    /// Specifies no date output, with the specified time style.
    case none(TimeFormatStyle)

    /// Specifies short output, such as 11/23/37, with the specified time style.
    case short(TimeFormatStyle)

    /// Specifies medium output, such as Nov 23, 1937, with the specified time style.
    case medium(TimeFormatStyle)

    /// Specifies long output, such as November 23, 1937, with the specified time style.
    case long(TimeFormatStyle)

    /// Specifies RFC 2822 output, such as Tue, 23 Nov 1937 15:30:32 -0800.
    case rfc2822

    /// Specifies ISO 8601 output, such as 1937-11-23T15:30:32-08:00, with time optionally included.
    /// - Parameter includeTime: Whether only the date is formatted or the time is also included.
    case iso8601(includeTime: Bool)

    /// Specifies relative date formatting, such as Today, 9:41 AM, with the specified time style.
    case relative(TimeFormatStyle)

    /// Specifies how long ago/until formatting, such as 82 years ago.
    case howLongAgoUntil

    /// Specifies a custom date format following the Unicode Technical Standard #35. For example, "EEE, dd MMM yyyy HH:mm:ss Z" to specify RFC 2822 output.
    case custom(String)
}
