//
//  NewRandomColors.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 04.06.2024.
//

import SwiftUI

struct NewRandomColors: View {
    @Binding var colors: [Color]
    @EnvironmentObject var coordinator: Coordinator<CatalogRouter, CatalogError>
    
    var body: some View {
        Text("Random Palette")
            .alert(isPresented: $coordinator.hasError, error: coordinator.error) {
                Button("Ok", action: { coordinator.dismissErrorAlert() })
            }
            .task {
                await generateRandom()
            }
    }
    
    private func generateRandom() async {
        let result = await PaletteAPI.getPalette(method: .random)
        
        switch result {
        case .success(let randomPalette):
            DispatchQueue.main.async {
                self.colors = randomPalette.colors
            }
        case .failure(let error):
            DispatchQueue.main.async {
                coordinator.presentAlert(error: CatalogError.map(description: error.localizedDescription))
            }
            print(error.localizedDescription)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var colors: [Color] = .init()
        
        var body: some View {
            VStack {
                NewRandomColors(colors: $colors)
                
                HStack {
                    ForEach(colors, id: \.self) { color in
                        Rectangle()
                            .fill(color)
                    }
                }
            }
        }
    }
    
    return PreviewWrapper()
        .environmentObject(Coordinator<CatalogRouter, CatalogError>())
}

