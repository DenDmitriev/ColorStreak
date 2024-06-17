//
//  MenuView.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 05.06.2024.
//

import SwiftUI
import FirebaseAnalytics

struct MenuView: View {
    @EnvironmentObject private var shop: PaletteShop
    
    @AppStorage(UserDefaultsKey.deviceColorSpace.key)
    private var colorSpace: DeviceColorSpace = .displayP3
    
    @AppStorage(UserDefaultsKey.lightMode.key)
    private var lightMode: LightMode = .automatic
    
    @AppStorage(UserDefaultsKey.colorTable.key)
    private var colorTable: ColorTable = .hsb
    
    @State private var showDeleteAlert = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("General") {
                    Picker("Theme", selection: $lightMode) {
                        ForEach(LightMode.allCases) { mode in
                            Text(mode.name)
                                .tag(mode)
                        }
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
                    
                    /*
                    // Test Crashlytics
                    Button("Crash", role: .destructive) {
                      fatalError("Crash was triggered")
                    }
                    */
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
        .analyticsScreen(name: AnalyticsEvent.screen(view: "\(type(of: self))"))
    }
    
    private func removeAllPalette() {
        shop.removeAll()
    }
}

#Preview {
    MenuView()
        .environmentObject(PaletteShop())
}
