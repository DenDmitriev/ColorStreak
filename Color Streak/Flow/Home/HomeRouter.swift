//
//  CatalogRouter.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 31.05.2024.
//

import SwiftUI

enum HomeRouter: NavigationRouter {
    case home
    case catalog
    case newPalette
    case editPalette(_ palette: Palette)
    case pickPalette(_ palette: Palette)
    case showPalette(_ palette: Palette)
    case detailPalette(_ palette: Palette)
    case share(_ palette: Palette)
    case contrast(_ palette: Palette)
    
    var title: String {
        switch self {
        case .home:
            return String(localized: "Main")
        case .catalog:
            return String(localized: "Catalog")
        case .newPalette:
            return String(localized: "New Palette")
        case .editPalette:
            return String(localized: "Edit Palette")
        case .showPalette:
            return String(localized: "Show Palette")
        case .detailPalette:
            return String(localized: "Detail Palette")
        case .share:
            return String(localized: "Share Palette")
        case .pickPalette:
            return String(localized: "Pick Palette")
        case .contrast:
            return String(localized: "Contrast")
        }
    }
    
    var id: Self {
        self
    }
    
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .home:
            HomeView()
        case .catalog:
            CatalogView()
        case .newPalette:
            NewPaletteView()
        case .pickPalette(let palette):
            PalettePickView(palette: palette)
        case .editPalette(let palette):
            PaletteEditView(palette: palette)
        case .showPalette(let palette):
            PaletteView(palette: palette)
        case .detailPalette(let palette):
            DetailPaletteView(palette: palette)
        case .share(let palette):
            ShareView(palette: palette)
        case .contrast(let palette):
            ContrastView(palette: palette)
        }
    }
}

extension HomeRouter {
    static func == (lhs: HomeRouter, rhs: HomeRouter) -> Bool {
        lhs.title == rhs.title
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
