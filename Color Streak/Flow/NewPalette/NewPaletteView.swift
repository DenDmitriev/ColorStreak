//
//  NewPaletteView.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 30.05.2024.
//

import SwiftUI
import Liquid
import Combine
import FirebaseAnalytics

struct NewPaletteView: View {
    
    @EnvironmentObject private var coordinator: Coordinator<HomeRouter, HomeError>
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
    
    private let nameMaxChars = 12
    
    enum FocusedField {
        case name, tags
    }
    
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("",
                              text: $newPalette.name,
                              prompt: Text("Palette name")
                    )
                    .focused($focusedField, equals: .name)
                    .onReceive(Just(newPalette.name)) { _ in
                        limitName(nameMaxChars)
                    }
                } header: {
                    Text("General")
                } footer: {
                    Text("The name must be no more than 12 characters long.")
                }
                
                
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
                
                Section {
                    Picker("Visualization", selection: $paletteVisualization) {
                        ForEach(PaletteVisualization.allCases) { visualization in
                            Text(visualization.name)
                                .tag(visualization)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    switch paletteVisualization {
                    case .rectangle:
                        RectanglePaletteView(colors: $newPalette.colors)
                            .aspectRatio(3, contentMode: .fit)
                            .padding(.horizontal, -22)
                            .padding(.vertical, -12)
                    case .liquid:
                        LiquidPaletteView(colors: $newPalette.colors)
                            .aspectRatio(1.0, contentMode: .fit)
                    case .metaBall:
                        MetaBallPaletteView(colors: $newPalette.colors)
                            .aspectRatio(1.0, contentMode: .fit)
                            .padding(.horizontal, -22)
                            .padding(.vertical, -12)
                    }
                } header: {
                    Text("Palette")
                }
                
                Section {
                    TextField("Add tag here", text: $tagText)
                        .focused($focusedField, equals: .tags)
                        .onSubmit {
                            newPalette.append(tag: tagText)
                            tagText.removeAll()
                        }
                    
                    Group {
                        switch tagsBinding {
                        case _ where tagsBinding.wrappedValue.isEmpty:
                            Text("No tags")
                                .font(.headline)
                                .foregroundStyle(HierarchicalShapeStyle.quinary)
                                .frame(maxWidth: .infinity, alignment: .center)
                        default:
                            TagView(layout: .vertical, tags: tagsBinding) { tag in
                                newPalette.remove(tag: tag)
                            }
                        }
                    }
                } header: {
                    Text("Tags")
                } footer: {
                    Text("Tag length must be from 3 to 9 characters.")
                }
            }
            .scrollDismissesKeyboard(.immediately)
            .scrollContentBackground(.hidden)
            .background(.appBackground)
            .navigationTitle("Create Palette")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("Method", systemImage: colorSource.systemImage) {
                        ForEach(ColorSource.allCases) { colorSource in
                            Button(colorSource.name, systemImage: colorSource.systemImage) {
                                self.colorSource = colorSource
                            }
                        }
                    }
                }
                
                ToolbarItem(placement: .bottomBar) {
                    VStack {
                        Button {
                            createPalette()
                        } label: {
                            Text("Create")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.primaryAction)
                    }
                }
            }
            .onAppear {
                focusedField = .name
                UITextField.appearance().clearButtonMode = .whileEditing
            }
            .analyticsScreen(name: AnalyticsEvent.screen(view: "\(type(of: self))"))
        }
    }
    
    var tagsBinding: Binding<[TagViewItem]> {
        Binding(
            get: { newPalette.tags.map({ TagViewItem(title: $0.tag, isSelected: false) }) },
            set: { _ in }
        )
    }
    
    private func createPalette() {
        if newPalette.name.isEmpty, let name = newPalette.generateName() {
            newPalette.name = name
        }
        if newPalette.tags.isEmpty {
            newPalette.autoTags()
        }
        shop.add(palette: newPalette)
        coordinator.push(.pickPalette(newPalette))
        coordinator.dismissSheet()
        
        Analytics.logEvent(AnalyticsEvent.createPalette.key, parameters: [
            AnalyticsParameterItemName: newPalette.name,
            AnalyticsParameterContentType: Palette.self
        ])
    }
    
    private func limitName(_ upper: Int) {
        if newPalette.name.count > upper {
            newPalette.name = String(newPalette.name.prefix(upper))
        }
    }
}

#Preview {
    NewPaletteView()
        .environmentObject(Coordinator<HomeRouter, HomeError>())
        .environmentObject(PaletteShop())
}
