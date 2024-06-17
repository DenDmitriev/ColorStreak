//
//  dE_CalculatorApp.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 17.05.2024.
//

import SwiftUI
import FirebaseAnalytics

@main
struct Color_Palette: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var shop: PaletteShop = .init()
    @StateObject private var chShop: CHPaletteShop = .init()
    
    @AppStorage(UserDefaultsKey.lightMode.key)
    private var lightMode: LightMode = .automatic
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    navigationTitleAppearance()
                    backButtonAppearance()
                }
                .preferredColorScheme(preferredColorScheme)
        }
        .environmentObject(shop)
        .environmentObject(chShop)
    }
    
    private var preferredColorScheme: ColorScheme {
        switch lightMode {
        case .automatic:
            return colorScheme
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
    
    private func navigationTitleAppearance() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.appPrimary]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.appPrimary]
    }
    
    private func backButtonAppearance() {
        let backImage = UIImage(systemName: "arrow.left")
        UINavigationBar.appearance().backIndicatorImage = backImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
    }
}
