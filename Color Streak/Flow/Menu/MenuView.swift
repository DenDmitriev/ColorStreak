//
//  MenuView.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 05.06.2024.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject private var shop: PaletteShop
    
    @AppStorage(UserDefaultsKey.deviceColorSpace.key)
    private var colorSpace: DeviceColorSpace = .displayP3
    
    @AppStorage(UserDefaultsKey.isDarkMode.key)
    private var isDarkMode: Bool = false
    
    @AppStorage(UserDefaultsKey.colorTable.key)
    private var colorTable: ColorTable = .hsb
    
    @State private var showDeleteAlert = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("General") {
                    Picker("Theme", selection: $isDarkMode) {
                        Text("Light")
                            .tag(false)
                        Text("Dark")
                            .tag(true)
                    }
                }
                
                Section("Palette") {
                    Picker("Color Space", selection: $colorSpace) {
                        ForEach(DeviceColorSpace.allCases) { colorSpace in
                            Text(colorSpace.name)
                                .tag(colorSpace)
                        }
                    }
                    
                    Picker("Color Info", selection: $colorTable) {
                        ForEach(ColorTable.allCases) { colorTable in
                            Text(colorTable.name)
                                .tag(colorTable)
                        }
                    }
                    
                    Button("Delete all palettes", role: .destructive) {
                        showDeleteAlert.toggle()
                    }
                }
                
                Section("Info") {
                    NavigationLink("About", destination: AboutView())
                }
            }
            .scrollContentBackground(.hidden)
            .background(.appBackground)
            .navigationTitle("Menu")
            .alert("Confirm deletion", isPresented: $showDeleteAlert) {
                Button("Delete", role: .destructive, action: removeAllPalette)
            } message: {
                Text("Are you sure you want to delete all palettes?")
            }
        }
    }
    
    private func removeAllPalette() {
        shop.removeAll()
    }
}

#Preview {
    MenuView()
        .environmentObject(PaletteShop())
}
