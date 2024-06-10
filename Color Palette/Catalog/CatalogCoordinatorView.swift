//
//  CatalogCoordinatorView.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 31.05.2024.
//

import SwiftUI

struct CatalogCoordinatorView: View {
    @EnvironmentObject private var coordinator: Coordinator<CatalogRouter, CatalogError>
    @EnvironmentObject private var shop: PaletteShop
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.appPrimary]
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(.catalog(shop: shop))
                .navigationTitle(CatalogRouter.catalog(shop: shop).title)
                .navigationDestination(for: CatalogRouter.self) { route in
                    coordinator.build(route)
                }
                .sheet(item: $coordinator.sheet, content: { route in
                    coordinator.build(route)
                })
                .fullScreenCover(item: $coordinator.cover) { route in
                    coordinator.build(route)
                }
                .alert(isPresented: $coordinator.hasError, error: coordinator.error) {
                    Button("Ok", action: { coordinator.hasError.toggle() })
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Menu", systemImage: "line.3.horizontal") {
                            coordinator.push(.menu)
                        }
                        .tint(.primary)
                    }
                }
        }
        .environmentObject(coordinator)
    }
}

#Preview {
    CatalogCoordinatorView()
        .environmentObject(PaletteShop(palettes: [.placeholder]))
        .environmentObject(Coordinator<CatalogRouter, CatalogError>())
}
