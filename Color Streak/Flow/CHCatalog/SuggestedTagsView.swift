//
//  SuggestedTagsView.swift
//  Color Palette
//
//  Created by Denis Dmitriev on 12.06.2024.
//

import SwiftUI

struct SuggestedTagsView: View {
    @Binding var tags: [ColorHunterTag]
    
    let action: (ColorHunterTag) -> Void
    
    @State private var size: CGSize = .zero
    
    var body: some View {
        GeometryReader { geometry in
            var width = CGFloat.zero
            var height = CGFloat.zero
            ZStack(alignment: .topLeading) {
                ForEach(tags.indices, id: \.self) { index in
                    item(for: tags[index])
                        .padding([.horizontal, .vertical], 4)
                        .alignmentGuide(.leading, computeValue: { dimensions in
                            if (abs(width - dimensions.width) > geometry.size.width) {
                                width = 0
                                height -= dimensions.height
                            }
                            let result = width
                            if tags[index].name == self.tags.last!.name {
                                width = 0 //last item
                            } else {
                                width -= dimensions.width
                            }
                            return result
                        })
                        .alignmentGuide(.top) { _ in
                            let result = height
                            if tags[index].name == self.tags.last!.name {
                                height = 0 // last item
                            }
                            return result
                        }
                }
            }
            .readSize { size in
                self.size = size
            }
        }
        .frame(height: size.height)
    }
    
    private func item(for tag: ColorHunterTag) -> some View {
        Button {
            action(tag)
        } label: {
            HStack {
                if let hex = tag.hex, let color = Color(hex: hex) {
                    Image(systemName: "circle.fill")
                        .foregroundStyle(color)
                } else {
                    
                }
                
                Text(tag.name)
            }
        }
        .lineLimit(1)
        .padding(.horizontal, 6)
        .padding(.vertical, 3)
        .background(.gray)
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

#Preview {
    SuggestedTagsView(tags: .constant(ColorHunterTag.allCases), action: { print($0.name) })
        .border(Color.black)
}
