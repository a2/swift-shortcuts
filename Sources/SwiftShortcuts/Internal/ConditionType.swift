enum ConditionType: Int, Encodable {
    case `is` = 4
    case isNot = 5
    case hasAnyValue = 100
    case doesNotHaveAnyValue = 101
    case contains = 99
    case doesNotContain = 999
    case beginsWith = 8
    case endsWith = 9
    case isGreaterThan = 2
    case isGreaterThanOrEqualTo = 3
    case isLessThan = 0
    case isLessThanOrEqualTo = 1
    case isBetween = 1003
    case isToday = 1002
    case isInTheLast = 1001
}
