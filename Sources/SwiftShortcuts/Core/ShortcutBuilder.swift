/// A custom parameter attribute that constructs shortcuts from closures.
@_functionBuilder public enum ShortcutBuilder {}

extension ShortcutBuilder {
    /// Builds an empty shortcut from a block containing no statements.
    /// - Returns: An empty shortcut
    public static func buildBlock() -> EmptyShortcut {
        EmptyShortcut()
    }

    /// Passes a single shortcut written as a child shortcut through unmodified.
    public static func buildBlock<Content>(_ content: Content) -> Content where Content: Shortcut {
        content
    }

    /// Provides support for "if" statements in multi-statement closures, producing an optional shortcut that is serialized only when the condition evaluates to true.
    public static func buildIf<Content>(_ content: Content?) -> Content? where Content: Shortcut {
        content
    }

    /// Provides support for "if-else" statements in multi-statement closures, producing ConditionalContent for the "then" branch.
    public static func buildEither<TrueContent, FalseContent>(first: TrueContent) -> _ConditionalContent<TrueContent, FalseContent> where TrueContent: Shortcut, FalseContent: Shortcut {
        _ConditionalContent(storage: .trueContent(first))
    }

    /// Provides support for "if-else" statements in multi-statement closures, producing ConditionalContent for the "else" branch.
    public static func buildEither<TrueContent, FalseContent>(second: FalseContent) -> _ConditionalContent<TrueContent, FalseContent> where TrueContent: Shortcut, FalseContent: Shortcut {
        _ConditionalContent(storage: .falseContent(second))
    }

    /// Builds a shortcut composed of 2 child shortcuts.
    public static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> TupleShortcut<(C0, C1)> where C0: Shortcut, C1: Shortcut {
        TupleShortcut((c0, c1))
    }

    /// Builds a shortcut composed of 3 child shortcuts.
    public static func buildBlock<C0, C1, C2>(_ c0: C0, _ c1: C1, _ c2: C2) -> TupleShortcut<(C0, C1, C2)> where C0: Shortcut, C1: Shortcut, C2: Shortcut {
        TupleShortcut((c0, c1, c2))
    }

    /// Builds a shortcut composed of 4 child shortcuts.
    public static func buildBlock<C0, C1, C2, C3>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) -> TupleShortcut<(C0, C1, C2, C3)> where C0: Shortcut, C1: Shortcut, C2: Shortcut, C3: Shortcut {
        TupleShortcut((c0, c1, c2, c3))
    }

    /// Builds a shortcut composed of 5 child shortcuts.
    public static func buildBlock<C0, C1, C2, C3, C4>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4) -> TupleShortcut<(C0, C1, C2, C3, C4)> where C0: Shortcut, C1: Shortcut, C2: Shortcut, C3: Shortcut, C4: Shortcut {
        TupleShortcut((c0, c1, c2, c3, c4))
    }

    /// Builds a shortcut composed of 6 child shortcuts.
    public static func buildBlock<C0, C1, C2, C3, C4, C5>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5) -> TupleShortcut<(C0, C1, C2, C3, C4, C5)> where C0: Shortcut, C1: Shortcut, C2: Shortcut, C3: Shortcut, C4: Shortcut, C5: Shortcut {
        TupleShortcut((c0, c1, c2, c3, c4, c5))
    }

    /// Builds a shortcut composed of 7 child shortcuts.
    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6) -> TupleShortcut<(C0, C1, C2, C3, C4, C5, C6)> where C0: Shortcut, C1: Shortcut, C2: Shortcut, C3: Shortcut, C4: Shortcut, C5: Shortcut, C6: Shortcut {
        TupleShortcut((c0, c1, c2, c3, c4, c5, c6))
    }

    /// Builds a shortcut composed of 8 child shortcuts.
    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7) -> TupleShortcut<(C0, C1, C2, C3, C4, C5, C6, C7)> where C0: Shortcut, C1: Shortcut, C2: Shortcut, C3: Shortcut, C4: Shortcut, C5: Shortcut, C6: Shortcut, C7: Shortcut {
        TupleShortcut((c0, c1, c2, c3, c4, c5, c6, c7))
    }

    /// Builds a shortcut composed of 9 child shortcuts.
    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8) -> TupleShortcut<(C0, C1, C2, C3, C4, C5, C6, C7, C8)> where C0: Shortcut, C1: Shortcut, C2: Shortcut, C3: Shortcut, C4: Shortcut, C5: Shortcut, C6: Shortcut, C7: Shortcut, C8: Shortcut {
        TupleShortcut((c0, c1, c2, c3, c4, c5, c6, c7, c8))
    }

    /// Builds a shortcut composed of 10 child shortcuts.
    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9) -> TupleShortcut<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)> where C0: Shortcut, C1: Shortcut, C2: Shortcut, C3: Shortcut, C4: Shortcut, C5: Shortcut, C6: Shortcut, C7: Shortcut, C8: Shortcut, C9: Shortcut {
        TupleShortcut((c0, c1, c2, c3, c4, c5, c6, c7, c8, c9))
    }
}
