//
//  CatalogRouter.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 31.05.2024.
//

import SwiftUI

enum CatalogRouter: NavigationRouter {
    case catalog(shop: PaletteShop)
    case newPalette
    case editPalette(_ palette: Palette)
    case pickPalette(_ palette: Palette)
    case showPalette(_ palette: Palette)
    case detailPalette(_ palette: Palette)
    case share(_ palette: Palette)
    case contrast(_ palette: Palette)
    case menu, about
    
    var title: String {
        switch self {
        case .catalog:
            return "Catalog"
        case .newPalette:
            return "New Palette"
        case .editPalette:
            return "Edit Palette"
        case .showPalette:
            return "Show Palette"
        case .detailPalette:
            return "Detail Palette"
        case .share:
            return "Share Palette"
        case .menu:
            return "Menu"
        case .about:
            return "About"
        case .pickPalette:
            return "Pick Palette"
        case .contrast:
            return "Contrast"
        }
    }
    
    var id: Self {
        self
    }
    
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .catalog(let shop):
            CatalogView(shop: shop)
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
        case .menu:
            MenuView()
        case .about:
            AboutView()
        case .contrast(let palette):
            ContrastView(palette: palette)
        }
    }
}

extension CatalogRouter {
    static func == (lhs: CatalogRouter, rhs: CatalogRouter) -> Bool {
        lhs.title == rhs.title
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
