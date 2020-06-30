import Foundation
import SwiftShortcuts

struct DictionaryShortcut: Shortcut {
    let makeUUID: () -> UUID
    
    init(makeUUID: @escaping () -> UUID = UUID.init) {
        self.makeUUID = makeUUID
    }
    
    var body: some Shortcut {
        GetDictionary([
            "array": [
                "Text without interpolation",
                "Text with interpolation \(.clipboard)",
                0,
                .number("\(.clipboard)"),
                true,
                false,
                [],
                ["text"],
                [:],
                ["key": "value"]
            ],
            "text": "Text without interpolation",
            "text_interpolated": "Text with interpolation \(.clipboard)",
            "number": 0,
            "number_interpolated": .number("\(.clipboard)"),
            "empty_array": [],
            "empty_dict": [:],
            "true": true,
            "false": false,
            "bool_ask": .boolean(Variable.askEachTime),
        ])
    }
}
