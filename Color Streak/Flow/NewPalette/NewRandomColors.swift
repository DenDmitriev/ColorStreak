//
//  NewRandomColors.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 04.06.2024.
//

import SwiftUI

struct NewRandomColors: View {
    @Binding var colors: [Color]
    @EnvironmentObject var coordinator: Coordinator<HomeRouter, HomeError>
    
    var body: some View {
        Section {
            Text("Random Palette")
        } header: {
            Text("")
        }  footer: {
            Text("Random color selection.")
        }
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
                coordinator.presentAlert(error: HomeError.map(description: error.localizedDescription))
            }
            print(error.localizedDescription)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var colors: [Color] = .init()
        
        var body: some View {
            List {
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
        .environmentObject(Coordinator<HomeRouter, HomeError>())
}

