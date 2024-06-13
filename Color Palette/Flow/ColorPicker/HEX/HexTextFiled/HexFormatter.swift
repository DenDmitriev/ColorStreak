//
//  HexFormatter.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 28.05.2024.
//

import Foundation

class HexFormatter: Formatter {
    private func isValidHex(_ value: String) -> Bool {
        let hex = value.filter { $0.isHexDigit }
        return hex.isEmpty
    }
    
    override func string(for obj: Any?) -> String? {
        guard let value = obj as? String else { return nil }
        
        var hex = value
        if hex.first == "#" {
            hex.removeFirst()
        }
        if hex.count > 6 {
            hex.removeLast(hex.count - 6)
        }
        hex = hex.filter { character in
            character.isHexDigit
        }
        hex = hex.uppercased()
        
        return "#\(hex)"
    }
    
    override func getObjectValue(
        _ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
        for string: String,
        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?
    ) -> Bool {
        let hexValue: String
        if string.contains("#") {
            hexValue = String(string.dropFirst())
        } else {
            hexValue = string
        }
        
        obj?.pointee = hexValue as AnyObject
        return true
    }
    
    override func isPartialStringValid(
        _ partialString: String,
        newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?,
        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?
    ) -> Bool {
        guard partialString.count <= 6 else { return false }
        return isValidHex(partialString)
    }
}
