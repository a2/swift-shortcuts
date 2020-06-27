@_functionBuilder public enum ActionBuilder {}

extension ActionBuilder {
    public static func buildBlock() -> EmptyAction {
        EmptyAction()
    }

    public static func buildBlock<Content>(_ content: Content) -> Content where Content: Action {
        content
    }

    public static func buildIf<Content>(_ content: Content?) -> Content? where Content: Action {
        content
    }

    public static func buildEither<TrueContent, FalseContent>(first: TrueContent) -> ConditionalContent<TrueContent, FalseContent> where TrueContent: Action, FalseContent: Action {
        ConditionalContent(storage: .trueContent(first))
    }

    public static func buildEither<TrueContent, FalseContent>(second: FalseContent) -> ConditionalContent<TrueContent, FalseContent> where TrueContent: Action, FalseContent: Action {
        ConditionalContent(storage: .falseContent(second))
    }

    public static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> TupleAction<(C0, C1)> where C0: Action, C1: Action {
        TupleAction((c0, c1))
    }

    public static func buildBlock<C0, C1, C2>(_ c0: C0, _ c1: C1, _ c2: C2) -> TupleAction<(C0, C1, C2)> where C0: Action, C1: Action, C2: Action {
        TupleAction((c0, c1, c2))
    }

    public static func buildBlock<C0, C1, C2, C3>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) -> TupleAction<(C0, C1, C2, C3)> where C0: Action, C1: Action, C2: Action, C3: Action {
        TupleAction((c0, c1, c2, c3))
    }

    public static func buildBlock<C0, C1, C2, C3, C4>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4) -> TupleAction<(C0, C1, C2, C3, C4)> where C0: Action, C1: Action, C2: Action, C3: Action, C4: Action {
        TupleAction((c0, c1, c2, c3, c4))
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5) -> TupleAction<(C0, C1, C2, C3, C4, C5)> where C0: Action, C1: Action, C2: Action, C3: Action, C4: Action, C5: Action {
        TupleAction((c0, c1, c2, c3, c4, c5))
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6) -> TupleAction<(C0, C1, C2, C3, C4, C5, C6)> where C0: Action, C1: Action, C2: Action, C3: Action, C4: Action, C5: Action, C6: Action {
        TupleAction((c0, c1, c2, c3, c4, c5, c6))
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7) -> TupleAction<(C0, C1, C2, C3, C4, C5, C6, C7)> where C0: Action, C1: Action, C2: Action, C3: Action, C4: Action, C5: Action, C6: Action, C7: Action {
        TupleAction((c0, c1, c2, c3, c4, c5, c6, c7))
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8) -> TupleAction<(C0, C1, C2, C3, C4, C5, C6, C7, C8)> where C0: Action, C1: Action, C2: Action, C3: Action, C4: Action, C5: Action, C6: Action, C7: Action, C8: Action {
        TupleAction((c0, c1, c2, c3, c4, c5, c6, c7, c8))
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9) -> TupleAction<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)> where C0: Action, C1: Action, C2: Action, C3: Action, C4: Action, C5: Action, C6: Action, C7: Action, C8: Action, C9: Action {
        TupleAction((c0, c1, c2, c3, c4, c5, c6, c7, c8, c9))
    }
}
