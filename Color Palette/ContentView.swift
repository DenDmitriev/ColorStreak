//
//  ContentView.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 17.05.2024.
// 

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var shop: PaletteShop
    @StateObject var coordinator: Coordinator<CatalogRouter, CatalogError> = .init()
    
    var body: some View {
        CatalogCoordinatorView()
            .environmentObject(coordinator)
    }
}

#Preview {
    ContentView()
        .environmentObject(PaletteShop())
}
