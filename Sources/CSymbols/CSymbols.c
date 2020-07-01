#include <CSymbols.h>

extern void _swift_shortcuts_makeAnyShortcut(void);
extern void _swift_shortcuts_decompose(void);

void *SwiftShortcutsGetAddressForSymbol(SwiftShortcutsSymbol symbol) {
    switch (symbol) {
        case SwiftShortcutsSymbolMakeAnyShortcut:
            return &_swift_shortcuts_makeAnyShortcut;
        case SwiftShortcutsSymbolDecompose:
            return &_swift_shortcuts_decompose;
        default:
            return NULL;
    }
}
