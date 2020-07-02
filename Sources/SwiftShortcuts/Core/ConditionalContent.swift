/// :nodoc:
public struct _ConditionalContent<TrueContent, FalseContent>: Shortcut where TrueContent: Shortcut, FalseContent: Shortcut {
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
