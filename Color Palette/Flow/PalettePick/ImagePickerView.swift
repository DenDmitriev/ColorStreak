//
//  ImagePickerView.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 04.06.2024.
//

import SwiftUI

struct ImagePickerView: View {
    @State var image: UIImage
    @Binding var colors: [Color]
    @Binding var selection: Int?
    
    @State private var radiusCursor: CGFloat = 24
    @State private var radiusCursorSelected: CGFloat = 48
    private let radiusCursorInitial: CGFloat = 24
    @State private var draggingIndex: Int?
    
    @State private var state: ProgressState = .empty
    @State private var colorsOnImage: [CGPoint: UIColor] = [:]
    @State private var knobPoints: [CGPoint] = []
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                switch state {
                case .empty:
                    EmptyView()
                case .loading:
                    progressView
                case .loaded:
                    ForEach(Array(zip(colors.indices, colors)), id: \.0) { index, color in
                        let bindingColor: Binding<Color> = .init {
                            color
                        } set: { color in
                            colors[index] = color
                        }
                        
                        KnobView(color: bindingColor)
                            .frame(width: widthPicker(index: index))
                            .position(knobPoints[index])
                            .onAppear {
                                let position = position(color: color, image: image, rect: geometry.frame(in: .global))
                                knobPoints[index] = position
                            }
                            .onTapGesture {
                                selection = index
                            }
                            .gesture(
                                DragGesture(coordinateSpace: .local)
                                    .onChanged { value in
                                        draggingIndex = index
                                        selection = index
                                        radiusCursor = radiusCursorInitial * 3
                                        let color = getColorInImage(geometry: geometry, value: value, image: image)
                                        bindingColor.wrappedValue = color
                                        
                                        let x = max(min(value.location.x, geometry.size.width), 0)
                                        let y = max(min(value.location.y, geometry.size.height), 0)
                                        knobPoints[index] = CGPoint(x: x, y: y)
                                    }
                                    .onEnded({ value in
                                        radiusCursor = radiusCursorInitial
                                        draggingIndex = nil
                                    })
                            )
                    }
                }
            }
        }
        .aspectRatio(aspectRatio(image: image), contentMode: .fit)
        .animation(.easeInOut, value: radiusCursor)
        .animation(.easeInOut, value: radiusCursorSelected)
        .onAppear {
            initKnobPoints()
            getColorsImage(image: image)
        }
    }
    
    var progressView: some View {
        ProgressView()
            .controlSize(.large)
            .padding(24)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 24))
    }
    
    private func initKnobPoints() {
        knobPoints = colors.map({ _ in CGPoint(x: 0, y: 0) })
    }
    
    private func getColorsImage(image: UIImage) {
        state = .loading
        Task(priority: .userInitiated) {
            let colorsOnImage = image.getColors()
            DispatchQueue.main.async {
                self.colorsOnImage = colorsOnImage
                state = .loaded
            }
        }
    }
    
    private func aspectRatio(image: UIImage?) -> CGFloat {
        guard let image else { return 1 }
        let size = image.size
        let aspectRatio = size.width / size.height
        return aspectRatio
    }
    
    private func widthPicker(index: Int) -> CGFloat {
        let isSelected = index == selection
        var width = isSelected ? radiusCursorSelected : radiusCursorInitial
        let isDragging = index == draggingIndex
        if isDragging {
            width = radiusCursor
        }
        
        return width
    }
    
    private func position(color: Color, image: UIImage, rect: CGRect) -> CGPoint {
        let rgb = UIColor(color).rgb
        guard let pointColor = colorsOnImage.first(where: { point, pointColor in
            return pointColor.rgb.isEqual(with: rgb, accuracy: 5)
        }) else { return .zero }
        
        let scaleX = rect.width / image.size.width
        let scaleY = rect.height / image.size.height
        
        let scaledX = max(min(pointColor.key.x * scaleX, rect.size.width), 0)
        let scaledY = max(min(pointColor.key.y * scaleY, rect.size.height), 0)
        
        let point = CGPoint(x: scaledX, y: scaledY)
        return point
    }
    
    private func getColorInImage(geometry: GeometryProxy, value: DragGesture.Value, image: UIImage) -> Color {
        let scaledPoint = value.location
        
        let scaleX = geometry.frame(in: .global).width / image.size.width
        let scaleY = geometry.frame(in: .global).height / image.size.height
        
        let globalMaxX = Int(image.size.width - 1)
        let globalMaxY = Int(image.size.height - 1)
        let globalX = scaledPoint.x.rounded() / scaleX
        let globalY = scaledPoint.y.rounded() / scaleY
        
        let globalXRounded = max(min(Int(globalX), globalMaxX), 0)
        let globalYRounded = max(min(Int(globalY), globalMaxY), 0)
        
        let globalPoint = CGPoint(x: globalXRounded, y: globalYRounded)
        let uiColor = image.getColor(point: globalPoint)
        
        return Color(uiColor)
    }
    
    enum ProgressState {
        case empty
        case loading
        case loaded
    }
}

#Preview {
    struct PreviewWrapper: View {
        @StateObject private var palette: Palette = .circleImages
        
        var body: some View {
            ImagePickerView(image: palette.image!.resizeImage(width: 100)!, colors: $palette.colors, selection: $palette.selection)
        }
    }
    
    return PreviewWrapper()
}
