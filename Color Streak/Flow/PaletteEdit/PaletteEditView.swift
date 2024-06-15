//
//  PaletteEditView.swift
//  Color Palette
//
//  Created by Denis Dmitriev on 05.06.2024.
//

import SwiftUI
import FirebaseAnalytics

struct PaletteEditView: View {
    @EnvironmentObject private var coordinator: Coordinator<CatalogRouter, CatalogError>
    @ObservedObject var palette: Palette
    @StateObject var editPalette: Palette
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @Environment(\.dismiss) var dismiss
    
    init(palette: Palette) {
        self.palette = palette
        self._editPalette = StateObject(wrappedValue: Palette(colors: palette.colors, name: palette.name, colorSpace: palette.colorSpace))
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            HStack(spacing: .zero) {
                PaletteStackView(palette: palette, axis: .constant(.vertical))
                PaletteStackView(palette: editPalette, axis: .constant(.vertical))
            }
            .padding(.bottom, -24)
            
            AdjustControlView(palette: editPalette)
                .disabled(palette.isEmptyColors)
                .padding([.horizontal, .top])
                .padding(.bottom, safeAreaInsets.bottom)
                .background(.thickMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 24))
        }
        .onDisappear {
            saveColors()
        }
        .navigationBarBackButtonHidden()
        .ignoresSafeArea()
        .toolbar(.hidden, for: .tabBar)
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Button(role: .cancel) {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                }
                .padding(.leading, 6)
                .padding(.vertical, 2)
                .background {
                    Capsule()
                        .fill(.regularMaterial)
                }
                .tint(.primary)
            }
        })
        .analyticsScreen(name: AnalyticsEvent.screen(view: "\(type(of: self))"))
    }
    
    private func saveColors() {
        palette.colors = editPalette.colors
        palette.saveModel()
    }
}

#Preview {
    NavigationStack {
        PaletteEditView(palette: .placeholder)
            .environmentObject(Coordinator<CatalogRouter, CatalogError>())
    }
}
