//
//  ColorHuntPalette.swift
//  Color Palette
//
//  Created by Denis Dmitriev on 11.06.2024.
//

import Foundation

struct ColorHuntPalette: Decodable {
    let code: String
    
    var hexs: [String] {
        var codeWithSpace = ""
        let separator = " "
        for (index, char) in code.enumerated() {
            if index % 6 == .zero, index != .zero {
                codeWithSpace.append(separator)
            }
            codeWithSpace.append(char)
        }
        let hexs = codeWithSpace.components(separatedBy: separator)
        return hexs
    }
    
    var palette: Palette {
        Palette(hexs: hexs, name: "")
    }
}
