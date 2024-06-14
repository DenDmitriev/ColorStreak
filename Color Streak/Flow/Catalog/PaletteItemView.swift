//
//  PaletteItemView.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 30.05.2024.
//

import SwiftUI

struct PaletteItemView: View {
    @ObservedObject var palette: Palette
    @EnvironmentObject private var coordinator: Coordinator<CatalogRouter, CatalogError>
    @EnvironmentObject private var shop: PaletteShop
    
    @State private var showMenu = false
    
    var body: some View {
        VStack(spacing: .zero) {
            HStack(spacing: .zero) {
                ForEach(Array(zip(palette.colors.indices, palette.colors)), id: \.0) { index, color in
                    Rectangle()
                        .fill(color)
                }
            }
            .overlay(alignment: .bottomLeading, content: {
                if palette.isNew {
                    BudgeView(kind: .new)
                        .padding(8)
                }
            })
            .onTapGesture {
                showPaletteAction()
            }
            .overlay(content: {
                if showMenu {
                    ZStack {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                        
                        HStack {
                            Button("",systemImage: "eyedropper.halffull" , action: pickPaletteAction)
                            Button("",systemImage: "slider.horizontal.3" , action: editPaletteAction)
                            Button("",systemImage: "rectangle.portrait.inset.filled" , action: showPaletteAction)
                            Button("",systemImage: "square.fill.on.circle.fill" , action: contrastPaletteAction)
                        }
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.white)
                    }
                }
            })
            .animation(.easeIn(duration: 0.1), value: showMenu)
            .frame(height: 70)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            HStack(spacing: 20) {
                Text(palette.name.isEmpty ? String(localized: "Unknown") : palette.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button(action: { showMenu.toggle() }, label: {
                    Rectangle()
                        .fill(.background)
                        .frame(width: 24, height: 24)
                        .overlay {
                            Image(systemName: "ellipsis")
                        }
                })
            }
            .font(.system(size: 14, weight: .regular))
            .foregroundStyle(.primary)
            .padding(.horizontal)
            .padding(.vertical, 8)
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
}

#Preview {
    VStack {
        PaletteItemView(palette: .placeholder)
            .environmentObject(Coordinator<CatalogRouter, CatalogError>())
            .environmentObject(PaletteShop())
            .padding()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}

