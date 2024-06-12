//
//  TabCoordinatorView.swift
//  Color Palette
//
//  Created by Denis Dmitriev on 12.06.2024.
//

import SwiftUI

struct TabCoordinatorView: View {
    @EnvironmentObject var coordinator: TabCoordinator<TabRouter>
    
    var body: some View {
        TabView(selection: $coordinator.tab) {
            ForEach(TabRouter.allCases) { tab in
                coordinator.build(tab)
                    .tabItem {
                        Label(tab.title, systemImage: tab.systemImage)
                    }
            }
        }
        .environmentObject(coordinator)
    }
}

#Preview {
    TabCoordinatorView()
        .environmentObject(PaletteShop())
        .environmentObject(CHPaletteShop())
        .environmentObject(TabCoordinator<TabRouter>(tab: .catalog))
        .environmentObject(Coordinator<CatalogRouter, CatalogError>())
        .environmentObject(Coordinator<CHCatalogRouter, CatalogError>())
}
