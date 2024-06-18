//
//  MainView.swift
//  Color Streak
//
//  Created by Denis Dmitriev on 17.06.2024.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var coordinator: Coordinator<HomeRouter, HomeError>
    @EnvironmentObject var shop: PaletteShop
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 24) {
                // Catalog
                CatalogStackView()
                
                // Image Feature
                ImportImageButton()
                    .padding(.horizontal)
                
                // Library
                LibraryStackView()
                
                // Contrast Feature
                ContrastColorsButton()
                    .padding(.horizontal)
            }
        }
    }

}

#Preview {
    HomeView()
        .environmentObject(Coordinator<HomeRouter, HomeError>())
        .environmentObject(PaletteShop.placeholder)
        .environmentObject(CHPaletteShop())
}
