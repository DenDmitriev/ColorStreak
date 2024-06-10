//
//  PaletteView.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 30.05.2024.
//

import SwiftUI

struct PaletteView: View {
    @ObservedObject var palette: Palette
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.dismiss) private var dismiss
    
    @State private var showHex = true
    @State private var showInfo = false
    
    var body: some View {
        VStack {
            switch verticalSizeClass {
            case .regular:
                VStack(spacing: .zero) {
                    paletteView
                }
            case .compact:
                HStack(spacing: .zero) {
                    paletteView
                }
            default:
                EmptyView()
            }
        }
        .overlay(content: {
            if showInfo {
                InfoView(text: "Copied")
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            showInfo.toggle()
                        }
                    }
            }
        })
        .onTapGesture {
            showHex.toggle()
        }
        .gesture(DragGesture(minimumDistance: 100)
            .onEnded({ value in
                let deltaY = value.location.y - value.startLocation.y
                let deltaX = value.location.x - value.startLocation.x
                if deltaY > 0, deltaX < 50 {
                    dismiss()
                }
            }))
        .animation(.easeIn(duration: 0.12), value: showHex)
        .animation(.easeIn(duration: 0.12), value: showInfo)
        .ignoresSafeArea()
        .toolbar(showHex ? .visible : .hidden , for: .navigationBar)
    }
    
    var paletteView: some View {
        ForEach(Array(zip(palette.colors.indices, palette.colors)), id: \.0) { index, color in
            Rectangle()
                .fill(color)
                .overlay(alignment: verticalSizeClass == .regular ? .trailing : .bottom) {
                    if showHex {
                        Button(action: {
                            copyHex(color: color)
                        }, label: {
                            Text("#" + color.hex)
                                .font(.system(size: 16, weight: .semibold))
                                .fontDesign(.monospaced)
                                .foregroundStyle(.black)
                                .minimumScaleFactor(0.1)
                                .lineLimit(1)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 6)
                                .background {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(.white.opacity(0.5))
                                }
                                .padding()
                        })
                    }
                    
                }
        }
    }
    
    private func copyHex(color: Color) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = color.hex
        
        showInfo.toggle()
    }
    
    
}

#Preview {
    PaletteView(palette: Palette(colors: [.red, .orange, .yellow, .green, .cyan, .blue, .purple], name: "Palette"))
}

