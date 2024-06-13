//
//  TabRouter.swift
//  Color Palette
//
//  Created by Denis Dmitriev on 12.06.2024.
//

import SwiftUI

enum TabRouter: NavigationRouter, CaseIterable, Identifiable {
    case catalog
    case library
    case menu
    
    var id: Self {
        return self
    }
    
    var title: String {
        switch self {
        case .catalog:
            "Catalog"
        case .library:
            "Library"
        case .menu:
            "Menu"
        }
    }
    
    var systemImage: String {
        switch self {
        case .catalog:
            "rectangle.on.rectangle"
        case .library:
            "books.vertical"
        case .menu:
            "gear"
        }
    }
    
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .catalog:
            CatalogCoordinatorView()
        case .library:
            CHCatalogCoordinatorView()
        case .menu:
            MenuView()
        }
    }
}
