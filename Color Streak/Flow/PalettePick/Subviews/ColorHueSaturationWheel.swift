//
//  ColorHueSaturationWheel.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 27.05.2024.
//

import SwiftUI

struct ColorHueSaturationWheel: View {
    
    @Binding var colorSpace: DeviceColorSpace
    @Binding var colors: [Color]
    @Binding var selected: Int?
    
    @Binding var brightness: CGFloat
    
    @Binding var controller: PalettePickView.ColorController
    
    @State private var radiusCursor: CGFloat = 24
    @State private var radiusCursorSelected: CGFloat = 48
    private let radiusCursorInitial: CGFloat = 24
    @State private var draggingIndex: Int?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                CIHueSaturationValueGradientView(colorSpace: colorSpace.cgColorSpace, radius: geometry.size.width / 2, brightness: self.$brightness)
                
                ForEach(Array(zip(colors.indices, colors)), id: \.0) { index, color in
                    LineView(
                        start: .init(get: { colorPoint(color: color, size: geometry.size) }, set: { _ in }),
                        end: .init(get: { centerPoint(rect: geometry.frame(in: .local)) }, set: { _ in }),
                        color: .white
                    )
                }
                
                ForEach(Array(zip(colors.indices, colors)), id: \.0) { index, color in
                    let bindingColor: Binding<Color> = .init {
                        color
                    } set: { color in
                        colors[index] = color
                    }
                    
                    KnobView(color: bindingColor)
                        .frame(width: widthPicker(index: index))
                        .offset(x: radius(size: geometry.size, color: bindingColor.wrappedValue))
                        .rotationEffect(.degrees(-bindingColor.wrappedValue.hsb.hue360))
                        .onTapGesture {
                            selected = index
                        }
                        .gesture(
                            DragGesture(coordinateSpace: .global)
                                .onChanged { value in
                                    controller = .wheel
                                    draggingIndex = index
                                    selected = index
                                    radiusCursor = radiusCursorInitial * 3
                                    bindingColor.wrappedValue = getColorInWheel(rect: geometry.frame(in: .global), point: value.location)
                                }
                                .onEnded({ value in
                                    radiusCursor = radiusCursorInitial
                                    draggingIndex = nil
                                    controller = .slider
                                })
                        )
                }
                
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .animation(.easeInOut, value: radiusCursor)
        .animation(.easeInOut, value: radiusCursorSelected)
    }
    
    private func centerPoint(rect: CGRect) -> CGPoint {
        CGPoint(x: rect.midX, y: rect.midY)
    }
    
    private func colorPoint(color: Color, size: CGSize) -> CGPoint {
        enum Quarter: Int {
            case one, two, three, four
            
            init(degree: CGFloat) {
                let value = Int(degree / 90)
                self = .init(rawValue: value) ?? .one
            }
        }
        let quarter = Quarter(degree: color.hsb.hue360)
        let alpha = (color.hsb.hue360 / 90).truncatingRemainder(dividingBy: 1) * 90
        let c = color.hsb.saturation * size.width / 2
        var x = c * cos(alpha * .pi / 180)
        var y = c * sin(alpha * .pi / 180)
        switch quarter {
        case .one:
            y *= -1
        case .two:
            x *= -1
            y *= -1
        case .three:
            x *= -1
        default:
            break
        }
        switch quarter {
        case .two, .four:
            x = size.width / 2 + x
            y = size.height / 2 + y
            let temp = x
            x = y
            y = temp
        case .one, .three:
            x = size.width / 2 + x
            y = size.height / 2 + y
        }
        
        return .init(x: x, y: y)
    }
    
    private func radius(size: CGSize, color: Color) -> CGFloat {
        let radius = (size.width / 2) * color.hsb.saturation
        let radiusRanged = max(min(radius, size.width / 2), 0)
        return radiusRanged
    }
    
    private func atan2To360(_ angle: CGFloat) -> CGFloat {
        var result = angle
        if result < 0 {
            result = (2 * CGFloat.pi) + angle
        }
        return result * 180 / CGFloat.pi
    }
    
    private func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt(pow(xDist, 2) + pow(yDist, 2)))
    }
    
    private func getColorInWheel(rect: CGRect, point: CGPoint) -> Color {
        let y = rect.midY - point.y
        let x = point.x - rect.midX
        
        let angle = atan2To360(atan2(y, x)) / 360
        let hue = max(min(angle, 1), 0)
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = distance(center, point) / (rect.width / 2)
        let saturation = max(min(radius, 1), 0)
        
        let color = Color(hue: hue, saturation: saturation, brightness: brightness)
        
        return color
    }
    
    private func widthPicker(index: Int) -> CGFloat {
        let isSelected = index == selected
        var width = isSelected ? radiusCursorSelected : radiusCursorInitial
        let isDragging = index == draggingIndex
        if isDragging {
            width = radiusCursor
        }
        
        return width
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var colors: [Color] = [.red, .green, .blue]
        @State private var brightness: CGFloat = 1
        @State private var selected: Int? = 1
        @State private var colorSpace: DeviceColorSpace = .displayP3
        @State private var controller: PalettePickView.ColorController = .slider
        
        
        @State private var width: CGFloat = 300
        var body: some View {
            VStack {
                Slider(value: $width, in: 0...300)
                
                ColorHueSaturationWheel(colorSpace: $colorSpace, colors: $colors, selected: $selected, brightness: $brightness, controller: $controller)
                    .frame(width: width)
            }
        }
    }
    
    return PreviewWrapper()
}
