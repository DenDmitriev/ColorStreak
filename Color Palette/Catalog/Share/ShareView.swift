//
//  ShareView.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 03.06.2024.
//

import SwiftUI

struct ShareView: View {
    @ObservedObject var palette: Palette
    
    @AppStorage(UserDefaultsKey.shareColor.key)
    private var shareColor: ShareColor = .color
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Share", selection: $shareColor) {
                    ForEach(ShareColor.allCases) { shareColor in
                        Text(shareColor.name)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                switch shareColor {
                case .image:
                    ShareImageView(palette: palette)
                case .color:
                    ShareColorsView(palette: palette)
                }
            }
            .navigationTitle("Share Palette")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ShareView(palette: .placeholder)
}
