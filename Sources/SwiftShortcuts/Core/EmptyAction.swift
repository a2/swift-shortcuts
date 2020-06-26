import Foundation

public struct EmptyAction: Action {
    public typealias Body = Never
    public var body: Never { fatalError() }

    public init() {}
}
