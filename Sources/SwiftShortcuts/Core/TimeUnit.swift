/// A unit of time supported by the Shortcuts app. See `TimeSpanValue` for usage.
public enum TimeUnit: Int, Encodable {
    /// A time unit representing a number of years.
    case years = 4

    /// A time unit representing a number of months.
    case months = 8

    /// A time unit representing a number of weeks.
    case weeks = 8192

    /// A time unit representing a number of days.
    case days = 16

    /// A time unit representing a number of hours.
    case hours = 32

    /// A time unit representing a number of minutes.
    case minutes = 64

    /// A time unit representing a number of seconds.
    case seconds = 128
}
