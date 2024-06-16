//
//  BottomSheetView.swift
//  Color Palette
//
//  Created by Denis Dmitriev on 09.06.2024.
//

import SwiftUI

struct BottomSheetView<Content: View, Left: View, Right: View>: View {
    @Binding var isOpen: Bool
    @State var background: AnyShapeStyle
    
    let content: Content
    let rightToolBar: Right
    let leftToolBar: Left
    
    @State private var maxHeight: CGFloat = .zero
    @State private var heightToggle: CGFloat = .zero
    @GestureState private var translation: CGFloat = 0
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    init(
        isOpen: Binding<Bool>, background: AnyShapeStyle,
        @ViewBuilder content: () -> Content,
        @ViewBuilder rightControl: () -> Right,
        @ViewBuilder leftControl: () -> Left
    ) {
        self.content = content()
        self.leftToolBar = leftControl()
        self.rightToolBar = rightControl()
        self._isOpen = isOpen
        self._background = .init(wrappedValue: background)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                toolBar
                    .padding()
                    .readSize { size in
                        heightToggle = size.height
                    }
                
                content
                    .readSize { size in
                        maxHeight = size.height
                    }
            }
            .frame(width: geometry.size.width)
            .frame(maxHeight: maxHeight + heightToggle)
            .padding(.bottom, safeAreaInsets.bottom)
            .background(background)
            .cornerRadius(Constants.radius)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(self.offset + self.translation, 0))
            .animation(.spring, value: isOpen)
            .gesture(
                DragGesture(minimumDistance: 40).updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    let snapDistance = self.maxHeight * Constants.snapRatio
                    guard abs(value.translation.height) > snapDistance else {
                        return
                    }
                    self.isOpen = value.translation.height < 0
                }
            )
        }
    }
    
    private var minHeight: CGFloat {
        safeAreaInsets.bottom
    }
    
    private var offset: CGFloat {
        isOpen ? 0 : maxHeight  - safeAreaInsets.bottom
    }
    
    private var toolBar: some View {
        HStack {
            Capsule()
                .fill(Color.secondary)
                .frame(
                    width: Constants.indicatorWidth,
                    height: Constants.indicatorHeight
                ).onTapGesture {
                    self.isOpen.toggle()
                }
                .offset(y: -8)
        }
        .frame(maxWidth: .infinity)
        .overlay(alignment: .leading) {
            leftToolBar
                .frame(height: Constants.indicatorHeight)
                .padding(.leading, isOpen ? 0 : safeAreaInsets.bottom)
        }
        .overlay(alignment: .trailing) {
            rightToolBar
                .frame(height: Constants.indicatorHeight)
                .padding(.trailing, isOpen ? 0 : safeAreaInsets.bottom)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var isOpen = false
        
        var body: some View {
            Rectangle()
                .fill(Color.cyan)
                .overlay {
                    BottomSheetView(isOpen: $isOpen, background: AnyShapeStyle(.ultraThinMaterial)) {
                        Text("Text")
                            .frame(height: 300)
                    } rightControl: {
                        Image(systemName: "circle.fill")
                    } leftControl: {
                        Image(systemName: "rectangle.fill")
                    }
                }
                .edgesIgnoringSafeArea(.all)
        }
    }
    return PreviewWrapper()
}

fileprivate enum Constants {
    static let radius: CGFloat = 24
    static let indicatorHeight: CGFloat = 6
    static let indicatorWidth: CGFloat = 60
    static let snapRatio: CGFloat = 0.25
}
