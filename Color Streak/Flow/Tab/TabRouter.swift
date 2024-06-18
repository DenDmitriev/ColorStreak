//
//  TabRouter.swift
//  Color Palette
//
//  Created by Denis Dmitriev on 12.06.2024.
//

import SwiftUI

enum TabRouter: NavigationRouter, CaseIterable, Identifiable {
    case main
    case library
    case settings
    
    var id: Self {
        return self
    }
    
    var title: String {
        switch self {
        case .main:
            return String(localized: "Main")
        case .library:
            return String(localized: "Library")
        case .settings:
            return String(localized: "Settings")
        }
    }
    
    var systemImage: String {
        switch self {
        case .main:
            "square"
        case .library:
            "square.grid.3x3.square"
        case .settings:
            "ellipsis"
        }
    }
    
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .main:
            HomeCoordinatorView()
        case .library:
            CHCatalogCoordinatorView()
        case .settings:
            MenuView()
        }
    }
}
