//
//  DarkModeViewModifier.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 28.05.2024.
//

import SwiftUI

extension View {
    func lightMode(dark: Binding<Bool>) -> some View {
        modifier(DarkModeViewModifier(isDarkMode: dark))
    }
}

public struct DarkModeViewModifier: ViewModifier {
    @Binding var isDarkMode: Bool

    public func body(content: Content) -> some View {
        content
            .environment(\.colorScheme, isDarkMode ? .dark : .light)
            .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}
