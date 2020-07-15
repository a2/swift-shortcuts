
import AssociatedTypeRequirementsVisitor

private let typeEraser = ShortcutTypeEraser()
private let decomposer = ShortcutDecomposer()

// MARK: - AnyShortcut from Any

extension AnyShortcut {
    init?(_fromValue value: Any) {
        guard let action = typeEraser(value) else { return nil }

        self = action
    }
}

// MARK: - Actions from Any

func actionComponents(from value: Any) -> [Action]? {
    return decomposer(value)
}

// MARK: - ShortcutVisitor

private protocol ShortcutVisitor: AssociatedTypeRequirementsVisitor {
    associatedtype Visitor = ShortcutVisitor
    associatedtype Input = Shortcut
    associatedtype Output

    func callAsFunction<S : Shortcut>(_ shortcut: S) -> Output
}

private struct ShortcutTypeEraser : ShortcutVisitor {

    func callAsFunction<S : Shortcut>(_ shortcut: S) -> AnyShortcut {
        return AnyShortcut(shortcut)
    }

}

private struct ShortcutDecomposer : ShortcutVisitor {

    func callAsFunction<S : Shortcut>(_ shortcut: S) -> [Action] {
        return shortcut.decompose()
    }

}
