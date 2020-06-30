public enum DateFormatStyle: Hashable {
    case none(TimeFormatStyle)
    case short(TimeFormatStyle)
    case medium(TimeFormatStyle)
    case long(TimeFormatStyle)
    case rfc2822
    case iso8601(includeTime: Bool)
    case relative(TimeFormatStyle)
    case custom(String)
    case howLongAgoUntil
}
