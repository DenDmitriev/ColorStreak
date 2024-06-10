//
//  ShareColor.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 03.06.2024.
//

import Foundation

enum ShareColor: String, CaseIterable, Identifiable {
    case image = "Image"
    case color = "Color"
    
    var id: Self {
        self
    }
    
    var name: String {
        self.rawValue
    }
}
