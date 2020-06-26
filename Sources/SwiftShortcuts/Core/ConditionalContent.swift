public struct ConditionalContent<TrueContent, FalseContent>: Action where TrueContent: Action, FalseContent: Action {
    enum Storage {
        case trueContent(TrueContent)
        case falseContent(FalseContent)
    }

    let storage: Storage

    public typealias Body = Never
    public var body: Never { fatalError() }

    init(storage: Storage) {
        self.storage = storage
    }
}
