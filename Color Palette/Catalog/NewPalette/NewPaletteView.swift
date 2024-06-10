//
//  NewPaletteView.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 30.05.2024.
//

import SwiftUI
import Liquid

struct NewPaletteView: View {
    
    @EnvironmentObject private var coordinator: Coordinator<CatalogRouter, CatalogError>
    @EnvironmentObject private var shop: PaletteShop
    @StateObject var newPalette: Palette = .init()
    @Environment(\.dismiss) private var dismiss
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @AppStorage(UserDefaultsKey.paletteVisualization.key)
    private var paletteVisualization: PaletteVisualization = .rectangle
    
    @AppStorage(UserDefaultsKey.colorSource.key)
    private var colorSource: ColorSource = .harmony
    
    @State private var keyColor: Color = Color.random
    @State private var tagText: String = ""
    
    enum FocusedField {
        case name, tags
    }
    
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: .zero) {
                VStack(spacing: 16) {
                    TextField("",
                              text: $newPalette.name,
                              prompt: Text("Palette name")
                    )
                    .focused($focusedField, equals: .name)
                    .font(.title.weight(.semibold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 50)
                    
                    VStack {
                        switch colorSource {
                        case .harmony:
                            NewColorHarmony(colors: $newPalette.colors, keyColor: $keyColor)
                        case .random:
                            NewRandomColors(colors: $newPalette.colors)
                        case .from:
                            NewFromColors(colors: $newPalette.colors, keyColor: $keyColor)
                        case .image:
                            NewImageColors(palette: newPalette)
                        }
                    }
                    .padding()
                    .background(HierarchicalShapeStyle.quinary)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    
                    VStack {
                        TextField("Add tag here", text: $tagText)
                            .focused($focusedField, equals: .tags)
                            .textFieldStyle(.plain)
                            .onSubmit {
                                newPalette.append(tag: tagText)
                                tagText.removeAll()
                            }
                        
                        Group {
                            switch tagsBinding {
                            case _ where tagsBinding.wrappedValue.isEmpty:
                                Text("No tags")
                                    .font(.headline)
                                    .foregroundStyle(.secondary)
                            default:
                                TagView(layout: .horizontal, tags: tagsBinding) { tag in
                                    newPalette.remove(tag: tag)
                                }
                            }
                        }
                        .frame(height: 50)
                        .padding(.horizontal, -14)
                    }
                    .padding(14)
                    .background(HierarchicalShapeStyle.quinary)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                }
                .padding(16)
                
                ZStack {
                    switch paletteVisualization {
                    case .rectangle:
                        RectanglePaletteView(colors: $newPalette.colors)
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                    case .liquid:
                        LiquidPaletteView(colors: $newPalette.colors)
                            .padding(.horizontal, 24)
                            .padding(.bottom, 100)
                    case .metaBall:
                        MetaBallPaletteView(colors: $newPalette.colors)
                    }
                    
                    Picker("paletteVisualization", selection: $paletteVisualization) {
                        ForEach(PaletteVisualization.allCases) { visualization in
                            Text(visualization.name)
                        }
                    }
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .pickerStyle(.segmented)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding()
                }
                .overlay(alignment: .bottom) {
                    VStack {
                        Button {
                            createPalette()
                        } label: {
                            Text("Create")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.primaryAction)
                    }
                    .padding()
                    .padding(.bottom, safeAreaInsets.bottom)
                    .background(.regularMaterial)
                    .cornerRadius(24, corners: [.topLeft, .topRight])
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .navigationTitle("Create Palette")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("Method", systemImage: "arrow.clockwise.circle.fill") {
                        ForEach(ColorSource.allCases) { colorSource in
                            Button(colorSource.name, systemImage: colorSource.systemImage) {
                                self.colorSource = colorSource
                            }
                        }
                    }
                }
            })
            .onAppear {
                focusedField = .name
            }
        }
    }
    
    var tagsBinding: Binding<[TagViewItem]> {
        Binding(
            get: { newPalette.tags.map({ TagViewItem(title: $0.tag, isSelected: false) }) },
            set: { _ in }
        )
    }
    
    private func createPalette() {
        shop.add(palette: newPalette)
        coordinator.push(.pickPalette(newPalette))
        coordinator.dismissSheet()
    }
}

#Preview {
    NewPaletteView()
        .environmentObject(Coordinator<CatalogRouter, CatalogError>())
        .environmentObject(PaletteShop())
}
