//
//  ColorHarmony.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 02.06.2024.
//

import SwiftUI

enum ColorHarmony: String, Identifiable, Hashable, CaseIterable {
    case sequential = "Sequential"
    case monochrome = "Monochrome"
    case triangular = "Triangular"
    case complementary = "Complementary"
    case splitComplementary = "Split complementary"
    case square = "Square"
    case composite = "Composite"
    case tint = "Tint"
    
    var name: String {
        self.rawValue
    }
    
    var id: String {
        self.rawValue
    }
    
    func colors(initial: Color) -> [Color] {
        switch self {
        case .sequential:
            return sequential(initial: initial)
        case .monochrome:
            return monochrome(initial: initial)
        case .triangular:
            return triangular(initial: initial)
        case .complementary:
            return complementary(initial: initial)
        case .splitComplementary:
            return splitComplementary(initial: initial)
        case .square:
            return square(initial: initial)
        case .composite:
            return composite(initial: initial)
        case .tint:
            return tint(initial: initial)
        }
    }
    
    private func sequential(initial: Color, delta angle: Angle = .degrees(15)) -> [Color] {
        let previous = initial.rotated(angle: Angle(degrees: -angle.degrees))
        let prePrevious = previous.rotated(angle: Angle(degrees: -angle.degrees))
        let next = initial.rotated(angle: Angle(degrees: angle.degrees))
        let afterNext = next.rotated(angle: Angle(degrees: angle.degrees))
        
        let result = [prePrevious, previous, initial, next, afterNext]
        
        let colorSpace = initial.colorSpace
        guard colorSpace != previous.colorSpace else { return result }
        
        let convertedResult = result.map { color in
            color.converted(colorSpace: colorSpace)
        }
        return convertedResult
    }
    
    /// Нормализует значение для интервала  0...1 разворачивая в противоположную сторону
    private func deltaNormalized(_ delta: Double, value: Double) -> Double {
        if value + delta <= 0 {
            return delta * -1
        } else if value + delta >= 1 {
            return delta * -1
        } else {
            return delta
        }
    }
    
    private func monochrome(initial: Color) -> [Color] {
        let delta = -0.2
        
        let first = initial
        let second = initial.moved(
            deltaHue: .zero,
            deltaSaturation: deltaNormalized(delta, value: first.hsb.saturation),
            deltaBrightness: deltaNormalized(delta, value: first.hsb.brightness))
        let third = second.moved(
            deltaHue: .zero, 
            deltaSaturation: deltaNormalized(delta, value: second.hsb.saturation),
            deltaBrightness: deltaNormalized(delta, value: second.hsb.brightness))
        let fourth = third.moved(
            deltaHue: .zero, 
            deltaSaturation: deltaNormalized(delta, value: third.hsb.saturation),
            deltaBrightness: deltaNormalized(delta, value: third.hsb.brightness))
        let fifth = fourth.moved(
            deltaHue: .zero, 
            deltaSaturation: deltaNormalized(delta, value: fourth.hsb.saturation),
            deltaBrightness: deltaNormalized(delta, value: fourth.hsb.brightness))
        
        let result = [first, second, third, fourth, fifth]
        
        let colorSpace = initial.colorSpace
        guard colorSpace != second.colorSpace else { return result }
        
        let convertedResult = result.map { color in
            color.converted(colorSpace: colorSpace)
        }
        return convertedResult
    }
    
    private func triangular(initial: Color, deltaAngle: Angle = .degrees(120)) -> [Color] {
        let left = initial.rotated(angle: deltaAngle)
        let right = initial.rotated(angle: -deltaAngle)
        
        let deltaSecondary: Double = -1/3
        
        let initialSecondary = initial.moved(
            deltaHue: .zero,
            deltaSaturation: deltaNormalized(deltaSecondary, value: initial.hsb.saturation),
            deltaBrightness: deltaNormalized(deltaSecondary, value: initial.hsb.brightness)
        )
        let leftSecondary = left.moved(
            deltaHue: .zero,
            deltaSaturation: deltaNormalized(deltaSecondary, value: left.hsb.saturation),
            deltaBrightness: deltaNormalized(deltaSecondary, value: left.hsb.brightness)
        )
        let rightSecondary = right.moved(
            deltaHue: .zero,
            deltaSaturation: deltaNormalized(deltaSecondary, value: right.hsb.saturation),
            deltaBrightness: deltaNormalized(deltaSecondary, value: right.hsb.brightness)
        )
        
        let result = [left, leftSecondary, initial, initialSecondary, right, rightSecondary]
        
        let colorSpace = initial.colorSpace
        guard colorSpace != left.colorSpace else { return result }
        
        let convertedResult = result.map { color in
            color.converted(colorSpace: colorSpace)
        }
        return convertedResult
    }
    
    private func complementary(initial: Color) -> [Color] {
        let complementary = initial.rotated(angle: .degrees(180))
        var deltaSecondary: Double = -1/3
        let secondaryComplementary = complementary.moved(
            deltaHue: .zero,
            deltaSaturation: deltaNormalized(deltaSecondary, value: complementary.hsb.saturation),
            deltaBrightness: deltaNormalized(deltaSecondary, value: complementary.hsb.brightness)
        )
        deltaSecondary = -1/4
        let secondaryInitial = initial.moved(
            deltaHue: .zero,
            deltaSaturation: deltaNormalized(deltaSecondary, value: initial.hsb.saturation),
            deltaBrightness: deltaNormalized(deltaSecondary, value: initial.hsb.brightness)
        )
        let thirdInitial = secondaryInitial.moved(
            deltaHue: .zero,
            deltaSaturation: deltaNormalized(deltaSecondary, value: secondaryInitial.hsb.saturation),
            deltaBrightness: deltaNormalized(deltaSecondary, value: secondaryInitial.hsb.brightness)
        )
        
        let result = [initial, secondaryInitial, thirdInitial, complementary, secondaryComplementary]
        
        let colorSpace = initial.colorSpace
        guard colorSpace != complementary.colorSpace else { return result }
        
        let convertedResult = result.map { color in
            color.converted(colorSpace: colorSpace)
        }
        return convertedResult
    }
    
    private func splitComplementary(initial: Color) -> [Color] {
        return triangular(initial: initial, deltaAngle: .degrees(210))
    }
    
    private func square(initial: Color) -> [Color] {
        let aColor = initial
        let bColor = initial.rotated(angle: .degrees(90))
        let cColor = bColor.rotated(angle: .degrees(90))
        let dColor = cColor.rotated(angle: .degrees(90))
        
        let deltaSecondary: Double = -1/3
        let aColorSecondary = aColor.moved(
            deltaHue: .zero,
            deltaSaturation: deltaNormalized(deltaSecondary, value: aColor.hsb.saturation),
            deltaBrightness: deltaNormalized(deltaSecondary, value: aColor.hsb.brightness)
        )
        let bColorSecondary = bColor.moved(
            deltaHue: .zero,
            deltaSaturation: deltaNormalized(deltaSecondary, value: bColor.hsb.saturation),
            deltaBrightness: deltaNormalized(deltaSecondary, value: bColor.hsb.brightness)
        )
        let cColorSecondary = cColor.moved(
            deltaHue: .zero,
            deltaSaturation: deltaNormalized(deltaSecondary, value: cColor.hsb.saturation),
            deltaBrightness: deltaNormalized(deltaSecondary, value: cColor.hsb.brightness)
        )
        let dColorSecondary = dColor.moved(
            deltaHue: .zero,
            deltaSaturation: deltaNormalized(deltaSecondary, value: dColor.hsb.saturation),
            deltaBrightness: deltaNormalized(deltaSecondary, value: dColor.hsb.brightness)
        )
        
        let result = [aColor, aColorSecondary, bColor, bColorSecondary, cColor, cColorSecondary, dColor, dColorSecondary]
        
        let colorSpace = initial.colorSpace
        guard colorSpace != bColor.colorSpace else { return result }
        
        let convertedResult = result.map { color in
            color.converted(colorSpace: colorSpace)
        }
        return convertedResult
    }
    
    private func composite(initial: Color) -> [Color] {
        let complementary = initial.rotated(angle: .degrees(180))
        
        let deltaAngle = Angle(degrees: -30)
        let initialComposite = initial.rotated(angle: deltaAngle)
        let complementaryComposite = complementary.rotated(angle: deltaAngle)
        
        let deltaSecondary: Double = -1/3
        let secondaryInit = initial.moved(
            deltaHue: .zero,
            deltaSaturation: deltaNormalized(deltaSecondary, value: initial.hsb.saturation),
            deltaBrightness: deltaNormalized(deltaSecondary, value: initial.hsb.brightness))
        
        let result = [initial, secondaryInit, initialComposite, complementary, complementaryComposite]
        
        let colorSpace = initial.colorSpace
        guard colorSpace != complementary.colorSpace else { return result }
        
        let convertedResult = result.map { color in
            color.converted(colorSpace: colorSpace)
        }
        return convertedResult
    }
    
    private func tint(initial: Color) -> [Color] {
        let delta = -0.15
        
        let first = initial
        let second = first.brightened(delta: deltaNormalized(delta, value: first.hsb.brightness))
        let third = second.brightened(delta: deltaNormalized(delta, value: second.hsb.brightness))
        let fourth = third.brightened(delta: deltaNormalized(delta, value: third.hsb.brightness))
        let fifth = fourth.brightened(delta: deltaNormalized(delta, value: fourth.hsb.brightness))
        
        let result = [first, second, third, fourth, fifth]
        
        let colorSpace = initial.colorSpace
        guard colorSpace != second.colorSpace else { return result }
        
        let convertedResult = result.map { color in
            color.converted(colorSpace: colorSpace)
        }
        return convertedResult
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var harmony: ColorHarmony = .tint
        @State private var keyColor: Color = Color(hue: 0, saturation: 1, brightness: 1)
        
        var body: some View {
            VStack(spacing: .zero) {
                ForEach(harmony.colors(initial: keyColor), id: \.self) { color in
                    Rectangle()
                        .fill(color)
                        .overlay {
                            Text(color.hsb.description)
                        }
                }
            }
            .ignoresSafeArea()
        }
    }
    
    return PreviewWrapper()
}
