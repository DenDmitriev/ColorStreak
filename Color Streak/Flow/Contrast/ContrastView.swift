//
//  ContrastView.swift
//  Color Palette
//
//  Created by Denis Dmitriev on 08.06.2024.
//

import SwiftUI
import DominantColors
import FirebaseAnalytics

struct ContrastView: View {
    @ObservedObject var palette: Palette
    
    @State private var contrast: ContrastWCAG?
    @State private var foregroundIndex: Int = 0
    @State private var backgroundIndex: Int = 1
    @State var background: Color = .clear
    @State var foreground: Color = .clear
    
    @State private var ifForegroundSelection = true
    @State private var showPicker = false
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ContrastPickerView(foreground: $foreground, background: $background)
                    .shadow(color: .black.opacity(0.12), radius: 16)
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 50, maximum: 100))], alignment: .center) {
                    ForEach(Array(zip(palette.colors.indices, palette.colors)), id: \.0) { index, color in
                        
                        let isBackground = backgroundIndex == index
                        let isForeground = foregroundIndex == index
                        let material = (colorScheme == .light) ? Material.ultraThick : Material.ultraThin
                        Circle()
                            .fill(color)
                            .overlay {
                                Circle()
                                    .stroke(material, lineWidth: isBackground ? 8 : 0)
                                    .padding(8)
                            }
                            .overlay {
                                Circle()
                                    .fill(material)
                                    .frame(width: isForeground ? 16 : 0)
                            }
                        
                            .shadow(color: .black.opacity(0.12), radius: 8)
                            .onTapGesture {
                                if index == foregroundIndex || index == backgroundIndex {
                                    ifForegroundSelection = (index == foregroundIndex)
                                } else {
                                    if ifForegroundSelection {
                                        foregroundIndex = index
                                    } else {
                                        backgroundIndex = index
                                    }
                                }
                            }
                    }
                }
                
                VStack(spacing: 18) {
                    ContrastValueView(contrast: $contrast)
                    DeltaColorValueView(reference: $background, sample: $foreground)
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 24))
                
                ContrastPreviewView(background: $background, foreground: $foreground, compliance: .AA, element: .normalText) {
                    ContrastNormalTextView()
                }
                .clipShape(RoundedRectangle(cornerRadius: 24))
                
                ContrastPreviewView(background: $background, foreground: $foreground, compliance: .AA, element: .largeText) {
                    ContrastLargeTextView()
                }
                .clipShape(RoundedRectangle(cornerRadius: 24))
                
                ContrastPreviewView(background: $background, foreground: $foreground, compliance: .AA, element: .uiComponents) {
                    ContrastShapeView()
                }
                .clipShape(RoundedRectangle(cornerRadius: 24))
                
                ContrastResultView(contrast: $contrast)
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                
                ContrastBackgroundView(colors: $palette.colors, background: .white)
                ContrastBackgroundView(colors: $palette.colors, background: .black)
            }
            .padding()
        }
        .animation(.easeInOut, value: foregroundIndex)
        .animation(.easeInOut, value: backgroundIndex)
        .navigationTitle("Contrast")
        .onChange(of: [foregroundIndex, backgroundIndex]) { _, colorIndexes in
            let foregroundIndex = colorIndexes[0]
            foreground = palette.colors[foregroundIndex]
            let backgroundIndex = colorIndexes[1]
            background = palette.colors[backgroundIndex]
            updateResults(foregroundIndex: foregroundIndex, backgroundIndex: backgroundIndex)
        }
        .onChange(of: [foreground, background]) { _, colors in
            let foreground = colors[0]
            palette.colors[foregroundIndex] = foreground
            let background = colors[1]
            palette.colors[backgroundIndex] = background
            updateResults(foregroundIndex: foregroundIndex, backgroundIndex: backgroundIndex)
        }
        .onAppear {
            updateResults(foregroundIndex: foregroundIndex, backgroundIndex: backgroundIndex)
        }
        .onDisappear {
            palette.saveModel()
        }
        .analyticsScreen(name: AnalyticsEvent.screen(view: "\(type(of: self))"))
    }
    
    private var colorsRange: Range<Int> { 0..<palette.colors.count }
    
    private func updateResults(foregroundIndex: Int, backgroundIndex: Int) {
        guard colorsRange ~= foregroundIndex,
            colorsRange ~= backgroundIndex
        else { return }
        
        background = palette.colors[backgroundIndex]
        foreground = palette.colors[foregroundIndex]
        
        contrast = ContrastWCAG(foreground: foreground, background: background)
    }
}


#Preview {
    ContrastView(palette: .circleImages)
}
