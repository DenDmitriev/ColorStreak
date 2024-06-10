//
//  dE_CalculatorApp.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 17.05.2024.
//

import SwiftUI

@main
struct Color_Palette: App {
    @StateObject private var shop: PaletteShop = .init()
    
    @AppStorage(UserDefaultsKey.isDarkMode.key)
    private var isDarkMode: Bool = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    navigationTitleAppearance()
                    backButtonAppearance()
                }
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
        .environmentObject(shop)
    }
    
    private func navigationTitleAppearance() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.appPrimary]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.appPrimary]
    }
    
    private func backButtonAppearance() {
        let backImage = UIImage(systemName: "arrow.left")
        UINavigationBar.appearance().backIndicatorImage = backImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
//        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -150, vertical: 0), for:UIBarMetrics.default)
        UIToolbar.appearance().barTintColor = UIColor.red
    }
}
