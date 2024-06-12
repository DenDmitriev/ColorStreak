//
//  CHCatalogRouter.swift
//  Color Palette
//
//  Created by Denis Dmitriev on 12.06.2024.
//

import SwiftUI

enum CHCatalogRouter: NavigationRouter {
    case library
    case showPalette(_ palette: Palette)
    case share(_ palette: Palette)
    
    var title: String {
        switch self {
        case .library:
            return "Catalog"
        case .showPalette:
            return "Show Palette"
        case .share:
            return "Share Palette"
        }
    }
    
    var id: Self {
        self
    }
    
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .library:
            CHCatalogView()
        case .showPalette(let palette):
            PaletteView(palette: palette)
        case .share(let palette):
            ShareView(palette: palette)
        }
    }
}

extension CHCatalogRouter {
    static func == (lhs: CHCatalogRouter, rhs: CHCatalogRouter) -> Bool {
        lhs.title == rhs.title
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
