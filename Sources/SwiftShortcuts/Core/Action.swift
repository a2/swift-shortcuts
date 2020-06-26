public protocol Action {
    associatedtype Body: Action

    var body: Body { get }
}
