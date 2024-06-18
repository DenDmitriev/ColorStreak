//
//  PaletteHomeItemView.swift
//  Color Streak
//
//  Created by Denis Dmitriev on 17.06.2024.
//

import SwiftUI
import FirebaseAnalytics

struct PaletteHomeItemView: View {
    @ObservedObject var palette: Palette
    @EnvironmentObject private var tabCoordinator: TabCoordinator<TabRouter>
    @EnvironmentObject private var coordinator: Coordinator<HomeRouter, HomeError>
    @EnvironmentObject private var shop: PaletteShop
    @EnvironmentObject private var chShop: CHPaletteShop
    @State private var proxyColors: [Color]
    @State private var showMenu = false
    let kind: Kind
    
    enum Kind {
        case catalog, library
    }
    
    init(palette: Palette, kind: Kind = .catalog) {
        self.palette = palette
        proxyColors = palette.colors
        self.kind = kind
    }
    
    var body: some View {
        VStack {
            if !palette.isEmpty {
                HStack(spacing: .zero) {
                    ForEach(Array(zip(proxyColors.indices, proxyColors)), id: \.0) { index, color in
                        Rectangle()
                            .fill(color)
                    }
                }
                .onTapGesture {
                    showMenu.toggle()
                }            
                .overlay(content: {
                    if showMenu {
                        ZStack {
                            Rectangle()
                                .fill(.ultraThinMaterial)
                                .onTapGesture {
                                    showMenu.toggle()
                                }  
                            
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 30, maximum: 50), spacing: 4)], spacing: 4) {
                                switch kind {
                                case .catalog:
                                    Button("",systemImage: "eyedropper.halffull" , action: pickPaletteAction)
                                    Button("",systemImage: "slider.horizontal.3" , action: editPaletteAction)
                                    Button("",systemImage: "rectangle.portrait.inset.filled" , action: showPaletteAction)
                                    Button("",systemImage: "square.fill.on.circle.fill" , action: contrastPaletteAction)
                                case .library:
                                    Button("",systemImage: "plus.circle.fill" , action: addToCatalogAction)
                                    Button("",systemImage: "rectangle.portrait.inset.filled" , action: showPaletteAction)
                                    Button("",systemImage: "square.fill.on.circle.fill" , action: contrastPaletteAction)
                                }
                                
                            }
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(12)
                        }
                    }
                })
                .animation(.easeIn(duration: 0.1), value: showMenu)
            } else {
                ShimmerEffectView()
            }
        }
        .aspectRatio(1.0, contentMode: .fit)
        .frame(height: 100)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(alignment: .bottomLeading, content: {
            if palette.isNew {
                BudgeView(kind: .new)
                    .padding(8)
            }
        })
        .animation(.easeIn(duration: 0.1), value: showMenu)
        .onAppear {
            proxyColors = palette.colors
        }
    }
    
    private func editPaletteAction() {
        showMenu = false
        coordinator.push(.editPalette(palette))
    }
    
    private func pickPaletteAction() {
        showMenu = false
        coordinator.push(.pickPalette(palette))
    }
    
    private func showPaletteAction() {
        showMenu = false
        coordinator.present(cover: .showPalette(palette))
    }
    
    private func contrastPaletteAction() {
        showMenu = false
        coordinator.push(.contrast(palette))
    }
    
    private func addToCatalogAction() {
        showMenu = false
        shop.add(palette: palette)
        coordinator.push(.catalog)
        
        sendAnalyticsImportPalette()
    }
    
    private func sendAnalyticsImportPalette() {
        Analytics.logEvent(AnalyticsEvent.importPalette.key, parameters: [
            AnalyticsParameterContentType: Palette.self
        ])
    }
}

#Preview {
    VStack {
        PaletteHomeItemView(palette: .placeholder)
        PaletteHomeItemView(palette: .placeholder, kind: .library)
    }
        .environmentObject(Coordinator<HomeRouter, HomeError>())
        .environmentObject(PaletteShop())
        .environmentObject(CHPaletteShop())
}
