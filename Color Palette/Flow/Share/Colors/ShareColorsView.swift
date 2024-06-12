//
//  ShareColorsView.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 03.06.2024.
//

import SwiftUI

struct ShareColorsView: View {
    @ObservedObject var palette: Palette
    @State private var showInfo = false
    
    @AppStorage(UserDefaultsKey.colorTable.key)
    private var colorTable: ColorTable = .hex
    
    @State private var showShare: Bool = false
    
    var body: some View {
        VStack(spacing: .zero) {
            ScrollView {
                VStack {
                    ForEach(palette.colors, id: \.self) { color in
                        ShareColorItem(color: color, colorTable: $colorTable)
                            .onTapGesture {
                                copyColor(color: color)
                            }
                    }
                }
                .padding(.horizontal)
            }
            
            List {
                GridRow {
                    Picker("Color Info", selection: $colorTable) {
                        ForEach(ColorTable.allCases) { colorTable in
                            Text(colorTable.name)
                                .tag(colorTable)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(.appBackground)
            .frame(height: 44 * 1 + 50)
        }
        .overlay {
            if showInfo {
                InfoView(text: "Copied")
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            showInfo.toggle()
                        }
                    }
            }
        }
        .animation(.easeInOut, value: showInfo)
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Menu("Share", systemImage: "square.and.arrow.up") {
                    ForEach(ExportPalette.allCases) { export in
                        Button(export.name.uppercased()) {
                            copyPalette(export: export)
                        }
                    }
                }
            }
        })
    }
    
    private func copyPalette(export: ExportPalette) {
        let pasteboard = UIPasteboard.general
        switch export {
        case .css:
            pasteboard.string = palette.css()
        case .xml:
            pasteboard.string = palette.xml()
        }
        showInfo.toggle()
    }
    
    private func copyColor(color: Color) {
        let pasteboard = UIPasteboard.general
        switch colorTable {
        case .hsb:
            pasteboard.string = color.hsb.description
        case .rgb:
            pasteboard.string = color.rgb.description
        case .lab:
            pasteboard.string = color.lab.description
        case .cmyk:
            pasteboard.string = color.cmyk.description
        case .hex:
            pasteboard.string = color.hex
        }
        
        showInfo.toggle()
    }
}

#Preview {
    NavigationStack {
        ShareColorsView(palette: .placeholder)
    }
}
