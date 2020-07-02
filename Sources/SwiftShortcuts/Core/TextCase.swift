/// A way to capitalize text content.
public enum TextCase: String, Encodable {
    /// All characters are uppercase.
    case uppercase = "UPPERCASE"

    /// All characters are lowercase.
    case lowercase = "lowercase"

    /// Every word begins with a capital letter.
    case capitalizeEveryWord = "Capitalize Every Word"

    /// Every word begins with a capital letter as defined by title case.
    case capitalizeWithTitleCase = "Capitalize with Title Case"

    /// The first word begins with a capital letter.
    case capitalizeWithSentenceCase = "Capitalize with sentence case"

    /// Characters alternate between uppercase and lowercase.
    case capitalizeWithAlternatingCase = "cApItAlIzE wItH aLtErNaTiNg cAsE"
}
