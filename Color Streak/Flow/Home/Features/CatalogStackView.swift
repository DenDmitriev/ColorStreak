//
//  CatalogStackView.swift
//  Color Streak
//
//  Created by Denis Dmitriev on 17.06.2024.
//

import SwiftUI

struct CatalogStackView: View {
    
    @EnvironmentObject private var coordinator: Coordinator<HomeRouter, HomeError>
    @EnvironmentObject var shop: PaletteShop
    
    var body: some View {
        VStack(spacing: 8) {
            SectionHeader(title: String(localized: "Palettes"), action: toCatalog)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    if !shop.palettes.isEmpty {
                        ForEach(Array(zip(shop.palettes.indices, shop.palettes)), id: \.0) { index, palette in
                            let isFirst = index == 0
                            let isLast = index == shop.palettes.count - 1
                            PaletteHomeItemView(palette: palette)
                                .padding(.leading, isFirst ? 16 : 0)
                                .padding(.trailing, isLast ? 16 : 0)
                        }
                    } else {
                        PaletteAddHomeItemView()
                            .padding(.leading, 16)
                    }
                }
            }
        }        
        .task {
            if shop.palettes.isEmpty {
                await shop.fetchPalettes()
            }
        }
    }
    
    private func toCatalog() {
        coordinator.push(.catalog)
    }
}

#Preview {
    CatalogStackView()        
        .environmentObject(Coordinator<HomeRouter, HomeError>())
        .environmentObject(PaletteShop())
}
