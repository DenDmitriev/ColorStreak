//
//  CHPaletteItemView.swift
//  Color Palette
//
//  Created by Denis Dmitriev on 11.06.2024.
//

import SwiftUI

struct CHPaletteItemView: View {
    @ObservedObject var palette: Palette
    @EnvironmentObject private var coordinator: Coordinator<CatalogRouter, CatalogError>
    @EnvironmentObject private var chShop: PaletteShop
    
    @State private var showMenu = false
    
    var body: some View {
        VStack(spacing: .zero) {
            HStack(spacing: .zero) {
                ForEach(Array(zip(palette.colors.indices, palette.colors)), id: \.0) { index, color in
                    Rectangle()
                        .fill(color)
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
            
            HStack(spacing: 20) {
                Button(action: { showMenu.toggle() }, label: {
                    Image(systemName: "ellipsis")
                })
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .foregroundStyle(.primary)
            .font(.system(size: 14, weight: .regular))
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
    
    private func showPaletteAction() {
        showMenu = false
        coordinator.present(cover: .showPalette(palette))
    }
}

#Preview {
    VStack {
        CHPaletteItemView(palette: Palette(colors: [.red, .orange, .yellow, .green, .cyan, .blue, .purple], name: "Palette"))
            .environmentObject(Coordinator<CatalogRouter, CatalogError>())
            .environmentObject(PaletteShop())
            .padding()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}
