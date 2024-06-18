//
//  CatalogError.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 05.06.2024.
//

import Foundation

enum HomeError: Error, LocalizedError {
    case map(description: String)
    
    var errorDescription: String? {
        switch self {
        case .map(let description):
            return description
        }
    }
}
