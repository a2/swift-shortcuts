public protocol Shortcut {
    associatedtype Body: Shortcut

    var body: Body { get }
}
