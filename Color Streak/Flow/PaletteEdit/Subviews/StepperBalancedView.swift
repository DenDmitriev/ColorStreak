//
//  StepperBalancedView.swift
//  Color Palette
//
//  Created by Denis Dmitriev on 06.06.2024.
//

import SwiftUI

struct StepperBalancedView: View {
    @Binding var level: Double
    @Binding var formatter: ColorCoordinate
    @Binding private var levelProxy: Double
    
    init(level: Binding<Double>, formatter: Binding<ColorCoordinate>) {
        self._level = level
        self._formatter = formatter
        let length = (formatter.wrappedValue.range.upperBound - formatter.wrappedValue.range.lowerBound)
        self._levelProxy = Binding<Double> {
            level.wrappedValue * length
        } set: { levelProxy in
            level.wrappedValue = levelProxy / length
        }
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 1) {
            button(systemImage: "minus") {
                levelProxy = max(min(levelProxy - formatter.increment, formatter.range.upperBound/2), -formatter.range.upperBound/2)
            }
            .disabled(levelProxy == -formatter.range.upperBound / 2)
            
            Text(formatter.text(value: level))
                .multilineTextAlignment(.center)
                .frame(width: 60)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.secondary)
            
            button(systemImage: "plus") {
                levelProxy = max(min(levelProxy + formatter.increment, formatter.range.upperBound/2), -formatter.range.upperBound/2)
            }
            .disabled(levelProxy == formatter.range.upperBound / 2)
        }
        .frame(height: 24)
        .tint(.primary)
        .font(.headline)
    }
    
    private func button(systemImage: String, action: @escaping (() -> Void)) -> some View {
        Button {
            action()
        } label: {
            Image(systemName: systemImage)
        }
        .padding(8)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var levelDegree: Double = 0
        
        @State private var levelPercent: Double = 0.5
        
        @State private var levelDecimal: Double = 0.5
        
        @State private var levelNormal: Double = 0.5
        
        @State private var levelBalance: Double = 0.5
        
        
        var body: some View {
            VStack {
                StepperBalancedView(level: $levelDegree, formatter: .constant(.degree))
                StepperBalancedView(level: $levelPercent, formatter: .constant(.percent))
                StepperBalancedView(level: $levelDecimal, formatter: .constant(.decimal))
                StepperBalancedView(level: $levelNormal, formatter: .constant(.normal))
                StepperBalancedView(level: $levelBalance, formatter: .constant(.balance))
            }
            
        }
    }
    return PreviewWrapper()
//        .preferredColorScheme(.dark)
}

