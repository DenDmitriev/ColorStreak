//
//  CatalogCoordinatorView.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 31.05.2024.
//

import SwiftUI

struct HomeCoordinatorView: View {
    @EnvironmentObject private var coordinator: Coordinator<HomeRouter, HomeError>
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.appPrimary]
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(.home)
                .navigationTitle(HomeRouter.home.title)
                .navigationDestination(for: HomeRouter.self) { route in
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
    HomeCoordinatorView()
        .environmentObject(PaletteShop(palettes: [.placeholder]))
        .environmentObject(CHPaletteShop())
        .environmentObject(Coordinator<HomeRouter, HomeError>())
}
