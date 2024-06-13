//
//  ExportPalette.swift
//  Color Palette
//
//  Created by Denis Dmitriev on 07.06.2024.
//

import Foundation

enum ExportPalette: String, CaseIterable, Identifiable {
    case css, xml
    
    var id: String {
        self.rawValue
    }
    
    var name: String {
        self.rawValue
    }
}
