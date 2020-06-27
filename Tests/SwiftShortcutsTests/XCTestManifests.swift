import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(BatteryLevelTests.allTests),
        testCase(ClapAlongTests.allTests),
    ]
}
#endif
