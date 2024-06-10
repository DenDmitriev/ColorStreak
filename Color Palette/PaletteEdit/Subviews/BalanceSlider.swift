//
//  AdjustSlider.swift
//  Color Palette
//
//  Created by Denis Dmitriev on 06.06.2024.
//

import SwiftUI

struct BalanceSlider: View {
    let text: String
    @Binding var level: Double
    @State var coordinate: ColorCoordinate
    let showControl = true
    
    @State private var size: CGSize = .zero
    @State private var xOffset: CGFloat = .zero
    
    @State private var isDragging = false
    
    @State private var knobColor: Color = .white
    
    @State private var proxyLevel: Double = .zero
    @State private var initialLevel: Double
    @State private var triggerVibration: Bool = false
    
    init(text: String, level: Binding<Double>, coordinate: ColorCoordinate) {
        self.text = text
        self._level = level
        self.coordinate = coordinate
        initialLevel = level.wrappedValue
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                if !text.isEmpty {
                    Text(text)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(.secondary)
                        .font(.system(size: 12, weight: .semibold))
                }
                
                if showControl {
                    StepperBalancedView(level: $proxyLevel, formatter: $coordinate)
                }
            }
            .padding(.horizontal, 12)
            
            ZStack {
                Capsule()
                    .fill(HierarchicalShapeStyle.tertiary)
                    .frame(height: 8)
                    .overlay {
                        Rectangle()
                            .fill(.tint)
                            .frame(height: 8)
                            .frame(width: abs(proxyLevel) * size.width)
                            .offset(x: proxyLevel * size.width - proxyLevel * size.width / 2)
                    }
                    .gesture(DragGesture()
                        .onChanged { value in
                            isDragging = true
                            switch isZero {
                            case true:
                                let delta = value.location.x - value.startLocation.x
                                guard abs(delta) >= 12 else { return }
                                fallthrough
                            case false:
                                let x = max(min(value.location.x, size.width), 0)
                                xOffset = x - size.width / 2
                            }
                        }
                        .onEnded { _ in
                            isDragging = false
                        }
                    )
                    .onTapGesture { location in
                        let x = max(min(location.x, size.width), 0)
                        xOffset = x - size.width / 2
                        updateProxyLevel(offset: xOffset)
                    }
                
                KnobView(color: $knobColor)
                    .offset(x: xOffset)
                
            }
            .readSize { size in
                self.size = size
            }
            .overlay(content: {
                Text(coordinate.text(value: proxyLevel))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 4)
                    .background {
                        Capsule()
                            .fill(.ultraThinMaterial)
                    }
                    .padding(.top, -80)
                    .offset(x: xOffset)
                    .opacity(isDragging ? 1 : 0)
            })
            .onAppear {
                updateOffset(level: proxyLevel)
            }
            .frame(height: 24)
            .padding(.horizontal, 12)
            .onChange(of: proxyLevel) { _, newLevel in
                guard !isDragging else { return }
                updateOffset(level: newLevel)
            }
            .onChange(of: xOffset) { _, newXOffset in
                guard isDragging else { return }
                updateProxyLevel(offset: newXOffset)
            }
            .onChange(of: proxyLevel) { oldValue, newValue in
                var newLevel = initialLevel + newValue
                let accuracy = 0.9 * 1 / (coordinate.range.upperBound - coordinate.range.lowerBound)
                let initialAccuracyRange = (initialLevel - accuracy)...(initialLevel + accuracy)
                if initialAccuracyRange ~= newLevel {
                    newLevel = 0
                    proxyLevel = 0
                    triggerVibration.toggle()
                }
                self.level = newLevel
            }
            .sensoryFeedback(.selection, trigger: triggerVibration)
        }
    }
    
    private var isZero: Bool {
        proxyLevel == .zero
    }
    
    private func updateProxyLevel(offset: CGFloat) {
        let newLevel = max(min(offset / size.width, 0.5), -0.5)
        self.proxyLevel = newLevel
    }
    
    private func updateOffset(level: Double) {
        let amplitude = size.width
        let levelToWidth = max(min(level, 0.5), -0.5) * amplitude
        let newXOffset = max(min(levelToWidth, amplitude), -amplitude)
        if newXOffset != xOffset {
            xOffset = newXOffset
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var color: Color = .gray
        @State private var level: Double = 0
        @State private var gradient: LinearGradient = .linearGradient(colors: [Color.white, Color.black], startPoint: .leading, endPoint: .trailing)
        
        var body: some View {
            VStack {
                Text((level * 100).formatted())
                
                BalanceSlider(
                    text: "Label",
                    level: $level,
                coordinate: .normal)
            }
        }
    }
    
    return PreviewWrapper()
}
