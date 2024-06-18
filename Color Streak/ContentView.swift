//
//  ContentView.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 17.05.2024.
// 

import SwiftUI

struct ContentView: View {
    @StateObject var catalogCoordinator: Coordinator<HomeRouter, HomeError> = .init()
    @StateObject var libraryCoordinator: Coordinator<CHCatalogRouter, HomeError> = .init()
    @StateObject var coordinator: TabCoordinator<TabRouter> = .init(tab: .main)
    
    @StateObject private var palette: Palette = .circleImages
    
    var body: some View {
        TabCoordinatorView()
            .environmentObject(coordinator)
            .environmentObject(libraryCoordinator)
            .environmentObject(catalogCoordinator)
    }
}

#Preview {
    ContentView()
        .environmentObject(PaletteShop())
        .environmentObject(CHPaletteShop())
}
