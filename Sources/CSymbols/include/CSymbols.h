#ifndef CSymbols_h
#define CSymbols_h

#include <stdio.h>

typedef enum {
    SwiftShortcutsSymbolMakeAnyShortcut,
    SwiftShortcutsSymbolDecompose,
} SwiftShortcutsSymbol;

void *SwiftShortcutsGetAddressForSymbol(SwiftShortcutsSymbol symbol);

#endif /* CSymbols_h */
