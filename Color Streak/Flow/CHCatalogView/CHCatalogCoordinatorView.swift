//
//  CHCatalogCoordinatorView.swift
//  Color Palette
//
//  Created by Denis Dmitriev on 12.06.2024.
//

import SwiftUI

struct CHCatalogCoordinatorView: View {
    @EnvironmentObject private var coordinator: Coordinator<CHCatalogRouter, CatalogError>
    @EnvironmentObject private var shop: PaletteShop
    @EnvironmentObject private var chShop: CHPaletteShop
    
    typealias Router = CHCatalogRouter
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.appPrimary]
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(.library)
                .navigationTitle(Router.library.title)
                .navigationDestination(for: Router.self) { route in
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
        }
        .environmentObject(coordinator)
    }
}

#Preview {
    CHCatalogCoordinatorView()
        .environmentObject(PaletteShop())
        .environmentObject(CHPaletteShop())
        .environmentObject(Coordinator<CHCatalogRouter, CatalogError>())
}
