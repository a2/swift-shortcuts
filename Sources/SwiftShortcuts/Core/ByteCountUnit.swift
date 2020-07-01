/// A unit of information supported by the Shortcuts app. See `FileSize` for usage.
public enum ByteCountUnit: Int, Encodable {
    /// A unit respresenting a number of bytes.
    case bytes = 1

    /// A unit respresenting a number of kilobytes (1,000 bytes).
    case KB = 2

    /// A unit respresenting a number of megabytes (1,000,000 bytes).
    case MB = 4

    /// A unit respresenting a number of gigabytes (1 billion bytes).
    case GB = 8

    /// A unit respresenting a number of terabytes (1 trillion bytes).
    case TB = 16

    /// A unit respresenting a number of petabytes (1,000 trillion bytes).
    case PB = 32

    /// A unit respresenting a number of exabytes (1 million trillion bytes).
    case EB = 64

    /// A unit respresenting a number of zettabyte (1 billion trillion bytes).
    case ZB = 128
}
