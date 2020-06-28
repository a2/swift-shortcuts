@_functionBuilder public enum ShortcutBuilder {}

extension ShortcutBuilder {
    public static func buildBlock() -> EmptyShortcut {
        EmptyShortcut()
    }

    public static func buildBlock<Content>(_ content: Content) -> Content where Content: Shortcut {
        content
    }

    public static func buildIf<Content>(_ content: Content?) -> Content? where Content: Shortcut {
        content
    }

    public static func buildEither<TrueContent, FalseContent>(first: TrueContent) -> ConditionalContent<TrueContent, FalseContent> where TrueContent: Shortcut, FalseContent: Shortcut {
        ConditionalContent(storage: .trueContent(first))
    }

    public static func buildEither<TrueContent, FalseContent>(second: FalseContent) -> ConditionalContent<TrueContent, FalseContent> where TrueContent: Shortcut, FalseContent: Shortcut {
        ConditionalContent(storage: .falseContent(second))
    }

    public static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> TupleShortcut<(C0, C1)> where C0: Shortcut, C1: Shortcut {
        TupleShortcut((c0, c1))
    }

    public static func buildBlock<C0, C1, C2>(_ c0: C0, _ c1: C1, _ c2: C2) -> TupleShortcut<(C0, C1, C2)> where C0: Shortcut, C1: Shortcut, C2: Shortcut {
        TupleShortcut((c0, c1, c2))
    }

    public static func buildBlock<C0, C1, C2, C3>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) -> TupleShortcut<(C0, C1, C2, C3)> where C0: Shortcut, C1: Shortcut, C2: Shortcut, C3: Shortcut {
        TupleShortcut((c0, c1, c2, c3))
    }

    public static func buildBlock<C0, C1, C2, C3, C4>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4) -> TupleShortcut<(C0, C1, C2, C3, C4)> where C0: Shortcut, C1: Shortcut, C2: Shortcut, C3: Shortcut, C4: Shortcut {
        TupleShortcut((c0, c1, c2, c3, c4))
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5) -> TupleShortcut<(C0, C1, C2, C3, C4, C5)> where C0: Shortcut, C1: Shortcut, C2: Shortcut, C3: Shortcut, C4: Shortcut, C5: Shortcut {
        TupleShortcut((c0, c1, c2, c3, c4, c5))
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6) -> TupleShortcut<(C0, C1, C2, C3, C4, C5, C6)> where C0: Shortcut, C1: Shortcut, C2: Shortcut, C3: Shortcut, C4: Shortcut, C5: Shortcut, C6: Shortcut {
        TupleShortcut((c0, c1, c2, c3, c4, c5, c6))
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7) -> TupleShortcut<(C0, C1, C2, C3, C4, C5, C6, C7)> where C0: Shortcut, C1: Shortcut, C2: Shortcut, C3: Shortcut, C4: Shortcut, C5: Shortcut, C6: Shortcut, C7: Shortcut {
        TupleShortcut((c0, c1, c2, c3, c4, c5, c6, c7))
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8) -> TupleShortcut<(C0, C1, C2, C3, C4, C5, C6, C7, C8)> where C0: Shortcut, C1: Shortcut, C2: Shortcut, C3: Shortcut, C4: Shortcut, C5: Shortcut, C6: Shortcut, C7: Shortcut, C8: Shortcut {
        TupleShortcut((c0, c1, c2, c3, c4, c5, c6, c7, c8))
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9) -> TupleShortcut<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)> where C0: Shortcut, C1: Shortcut, C2: Shortcut, C3: Shortcut, C4: Shortcut, C5: Shortcut, C6: Shortcut, C7: Shortcut, C8: Shortcut, C9: Shortcut {
        TupleShortcut((c0, c1, c2, c3, c4, c5, c6, c7, c8, c9))
    }
}
