import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(LS8SwiftTests.allTests),
    ]
}
#endif
