#include <CSymbols.h>

void *makeAnyShortcutSymbol(void) {
    extern void _swift_shortcuts_makeAnyShortcut(void);
    return &_swift_shortcuts_makeAnyShortcut;
}

void *decomposeIntoActionsSymbol(void) {
    extern void _swift_shortcuts_decomposeIntoActions(void);
    return &_swift_shortcuts_decomposeIntoActions;
}
