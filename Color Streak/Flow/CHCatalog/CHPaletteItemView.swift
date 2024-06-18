//
//  CHPaletteItemView.swift
//  Color Palette
//
//  Created by Denis Dmitriev on 11.06.2024.
//

import SwiftUI
import FirebaseAnalytics

struct CHPaletteItemView: View {
    @ObservedObject var palette: Palette
    @EnvironmentObject private var tabCoordinator: TabCoordinator<TabRouter>
    @EnvironmentObject private var coordinator: Coordinator<HomeRouter, HomeError>
    @EnvironmentObject private var chShop: CHPaletteShop
    @EnvironmentObject var shop: PaletteShop
    
    @State private var showMenu = false
    
    var body: some View {
        VStack(spacing: .zero) {
            HStack(spacing: .zero) {
                if !palette.isEmpty {
                    ForEach(Array(zip(palette.colors.indices, palette.colors)), id: \.0) { index, color in
                        Rectangle()
                            .fill(color)
                    }
                } else {
                    ShimmerEffectView()
                }
            }
            .onTapGesture {
                showPaletteAction()
            }
            .overlay(content: {
                if showMenu {
                    ZStack {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                        
                        HStack {
                            Button("",systemImage: "plus.circle.fill" , action: addToCatalogAction)
                            
                            Button("",systemImage: "rectangle.portrait.inset.filled" , action: showPaletteAction)
                        }
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.white)
                    }
                }
            })
            .animation(.easeIn(duration: 0.1), value: showMenu)
            .frame(height: 70)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            HStack {
                Button(action: { showMenu.toggle() }, label: {
                    Rectangle()
                        .fill(.background)
                        .frame(width: 24, height: 24)
                        .overlay(alignment: .trailing) {
                            Image(systemName: "ellipsis")
                        }
                })
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .foregroundStyle(.primary)
            .font(.system(size: 14, weight: .regular))
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
    }
    
    private func showPaletteAction() {
        showMenu = false
        coordinator.present(cover: .showPalette(palette))
    }
    
    private func addToCatalogAction() {
        showMenu = false
        shop.add(palette: palette)
        tabCoordinator.change(.main)
        
        sendAnalyticsImportPalette()
    }
    
    private func sendAnalyticsImportPalette() {
        let tags = chShop.selectedTags.map({ $0.name }).joined(separator: ", ")
        let searchText = chShop.searchText
        Analytics.logEvent(AnalyticsEvent.importPalette.key, parameters: [
            AnalyticsParameterSearchTerm: "tags: \(tags), searchText: \(searchText)",
            AnalyticsParameterContentType: Palette.self
        ])
    }
}

#Preview {
    VStack {
        CHPaletteItemView(palette: Palette(colors: [.red, .orange, .yellow, .green, .cyan, .blue, .purple], name: "Palette"))
            .environmentObject(Coordinator<HomeRouter, HomeError>())
            .environmentObject(PaletteShop())
            .padding()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}
