//
//  ColorTheme.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 27.05.2024.
//

import SwiftUI
import FirebaseAnalytics

struct PalettePickView: View {
    @EnvironmentObject private var coordinator: Coordinator<CatalogRouter, CatalogError>
    @ObservedObject var palette: Palette
    let initialColors: [Color]
    
    @AppStorage(UserDefaultsKey.deviceColorSpace.key)
    private var colorSpace: DeviceColorSpace = .displayP3

    @AppStorage(UserDefaultsKey.lightMode.key)
    private var lightMode: LightMode = .automatic
    
    @AppStorage(UserDefaultsKey.colorTable.key)
    private var colorTable: ColorTable = .hsb
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @Environment(\.dismiss) private var dismiss
    
    @State private var pickerSize: CGSize = .zero
    @State private var colorPickerSource: ColorPickerSource = .wheel
    @State private var showControl = true
    @State private var controller: ColorController = .selection
    
    init(palette: Palette) {
        self.palette = palette
        self.initialColors = palette.colors
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            VStack {
                switch colorPickerSource {
                case .wheel:
                    ColorHueSaturationWheel(colorSpace: $colorSpace, colors: $palette.colors, selected: $palette.selection, brightness: brightness, controller: $controller)
                case .image:
                    if let image = palette.image {
                        ImagePickerView(image: image, colors: $palette.colors, selection: $palette.selection)
                        
                    } else {
                        Text("No image")
                            .font(.title2.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .frame(maxHeight: UIScreen.screenHeight / 2)
            
            ColorPaletteView(palette: palette, selection: $palette.selection, controller: $controller)
                .clipShape(RoundedRectangle(cornerRadius: 24))
        }
        .overlay(alignment: .trailing) {
            plusButton
                .padding(.bottom, 50)
        }
        .overlay(alignment: .leading) {
            minusButton
                .padding(.bottom, 50)
        }
        .overlay {
            BottomSheetView(isOpen: $showControl, background: AnyShapeStyle(Material.thickMaterial)) {
                ColorPickerView(color: selectedColor, initial: initialColor, colorSpace: $colorSpace, colorTable: $colorTable, controller: $controller)
                    .disabled(palette.isEmptyColors)
                    .padding(.horizontal)
                    .padding(.bottom, safeAreaInsets.bottom)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .readSize { size in
                        pickerSize = size
                    }
            } rightControl: {
                Picker("Color Table", selection: $colorTable) {
                    ForEach(ColorTable.allCases) { colorTable in
                        Text(colorTable.name)
                            .tag(colorTable)
                    }
                }
                .pickerStyle(.menu)
                .tint(.secondary)
            } leftControl: {
                Button {
                    showControl.toggle()
                } label: {
                    Image(systemName: "chevron.down.circle.fill")
                        .rotationEffect(.degrees(showControl ? 0 : 180))
                }
                .tint(.secondary)
            }
        }
        .background(Color(UIColor.tertiarySystemBackground))
        .ignoresSafeArea(edges: .bottom)
//        .lightMode(dark: $isDarkMode)
        .navigationTitle(palette.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .automatic) {
                menuActions
            }
            
            ToolbarItem(placement: .automatic) {
                Button(role: .destructive, action: cancelChanges) {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .onChange(of: colorSpace) { _, newColorSpace in
            palette.convert(device: newColorSpace)
        }
        .onAppear {
            if !palette.colors.isEmpty {
                palette.selection = .zero
            }
        }
        .onDisappear {
            palette.saveModel()
        }
        .analyticsScreen(name: AnalyticsEvent.screen(view: "\(type(of: self))"))
    }
    
    private func cancelChanges() {
        palette.colors = initialColors
    }
    
    private var minusButton: some View  {
        Button {
            palette.removeColorSelection()
        } label: {
            Image(systemName: "minus.circle.fill")
                .font(.headline)
        }
        .disabled(palette.isEmptyColors)
        .tint(.secondary)
        .padding(.leading)
    }
    
    private var plusButton: some View {
        Button  {
            palette.appendColor(colorSpace: colorSpace.rgbColorSpace)
        } label: {
            Image(systemName: "plus.circle.fill")
                .font(.headline)
        }
        .disabled(palette.isMaxColors)
        .tint(.secondary)
        .padding(.trailing)
    }
    
    private var selectedColor: Binding<Color> {
        Binding(
            get: {
                if let selection = palette.selection {
                    return palette.colors[selection]
                } else {
                    return .clear
                }
            }) { color in
                if let selection = palette.selection {
                    palette.colors[selection] = color
                }
            }
    }
    
    private var initialColor: Color? {
        guard let selection = palette.selection,
              0..<initialColors.count ~= selection
        else { return nil }
        return initialColors[selection]
    }
    
    private var brightness: Binding<CGFloat> {
        Binding<CGFloat>(
            get: {
                if let selection = palette.selection {
                    return palette.colors[selection].hsb.brightness
                } else {
                    return 1
                }
            },
            set: { brightness in
                if let selection = palette.selection {
                    let color = palette.colors[selection].hsb
                    return palette.colors[selection] = Color(hue: color.hue, saturation: color.brightness, brightness: brightness)
                }
            })
    }
    
    enum ColorPickerSource: String, Identifiable, CaseIterable {
        case wheel = "Wheel"
        case image = "Image"
        
        var id: Self {
            self
        }
        
        var name: String {
            self.rawValue
        }
    }
    
    private var menuActions: some View {
        Menu {
            Menu {
                ForEach(LightMode.allCases) { mode in
                    Button(mode.name, systemImage: mode.systemImage, action: {
                        lightMode = mode
                    })
                }
            } label: {
                Label("Light mode", systemImage: lightMode.systemImage)
            }
            
            Menu {
                Picker("Color Space", selection: $colorSpace) {
                    ForEach(DeviceColorSpace.allCases) { colorSpace in
                        Text(colorSpace.name)
                            .tag(colorSpace)
                    }
                }
            } label: {
                Label("Color Space", systemImage: "cube.fill")
            }
            
            if palette.image != nil {
                Menu{
                    Picker("Picker", selection: $colorPickerSource) {
                        ForEach(ColorPickerSource.allCases) { colorPickerSource in
                            Text(colorPickerSource.name)
                                .tag(colorPickerSource)
                        }
                    }
                } label: {
                    Label("Picker", systemImage: "eyedropper.halffull")
                }
            }
        } label: {
            Label("Settings", systemImage: "gearshape.fill")
        }
    }
}

extension PalettePickView {
    enum ColorController {
        case wheel
        case slider
        case selection
    }
}

#Preview {
    struct PreviewWrapper: View {
        @StateObject private var palette: Palette = .placeholder
        
        var body: some View {
            PalettePickView(palette: palette)
        }
    }
    
    return NavigationStack {
        PreviewWrapper()
            .environmentObject(Coordinator<CatalogRouter, CatalogError>())
    }
}
