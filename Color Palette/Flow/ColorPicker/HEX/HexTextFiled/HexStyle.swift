//
//  HexStyle.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 28.05.2024.
//

import SwiftUI

extension FormatStyle where Self == HexStyle {
    static var hex: HexStyle {
        return HexStyle(parseStrategy: HexStrategy(prefix: "#", uppercase: true))
    }
}

struct HexStyle: ParseableFormatStyle {
    var parseStrategy: HexStrategy
    
    func format(_ value: String) -> String {
        do {
            let result = try parseStrategy.parse(value)
            return result
        } catch {
            return ""
        }
    }
}

struct HexStrategy: ParseStrategy {
    let prefix: String
    let uppercase: Bool
    
    func parse(_ value: String) throws -> String {
        var hex = value
        if hex.contains(prefix) {
            hex.removeFirst(prefix.count)
        }
        if hex.count > 6 {
            hex.removeLast(hex.count - 6)
        }
        hex = hex.filter { character in
            character.isHexDigit
        }
        if uppercase {
            hex = hex.uppercased()
        }
        
        return "\(prefix)" + hex
    }
}
