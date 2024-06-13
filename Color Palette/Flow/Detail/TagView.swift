//
//  TagView.swift
//  Color Palette
//
//  Created by Denis Dmitriev on 07.06.2024.
//

import SwiftUI

struct TagViewItem: Hashable {
    
    var title: String
    var isSelected: Bool
    
    static func == (lhs: TagViewItem, rhs: TagViewItem) -> Bool {
        return lhs.isSelected == rhs.isSelected
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(isSelected)
    }
}

struct TagView: View {
    enum Layout {
        case vertical, horizontal
    }
    let layout: Layout
    @Binding var tags: [TagViewItem]
    var removeAction: (String) -> Void
    
    @State private var totalHeight = CGFloat.zero
    
    var body: some View {
        VStack {
            switch layout {
            case .vertical:
                GeometryReader { geometry in
                    generateVerticalContent(in: geometry)
                }
            case .horizontal:
                generateHorizontalContent()
            }
        }
        .frame(height: totalHeight)
    }
    
    private func generateHorizontalContent() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: [GridItem(.flexible(minimum: 40, maximum: 100))]) {
                ForEach(tags.indices, id: \.self) { index in
                    item(for: tags[index].title, isSelected: tags[index].isSelected)
                        .onTapGesture {
                            tags[index].isSelected.toggle()
                        }
                        .padding(.leading, index == 0 ? 16 : 0)
                        .padding(.trailing, index == (tags.count - 1) ? 16 : 0)
                }
            }
            .padding(.vertical, 4)
        }
    }

    @ViewBuilder
    private func generateVerticalContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        ZStack(alignment: .topLeading) {
            ForEach(tags.indices, id: \.self) { index in
                item(for: tags[index].title, isSelected: tags[index].isSelected)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width) {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if tags[index].title == self.tags.last!.title {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top) { _ in
                        let result = height
                        if tags[index].title == self.tags.last!.title {
                            height = 0 // last item
                        }
                        return result
                    }
                    .onTapGesture {
                        tags[index].isSelected.toggle()
                    }
            }
        }
        .readSize { size in
            totalHeight = size.height
        }
    }

    private func item(for text: String, isSelected: Bool) -> some View {
        HStack(alignment: .center) {
            Text(text)
            
            Button(action: {
                removeAction(text)
                tags.removeAll { tagItem in
                    tagItem.title == text
                }
            }, label: {
                Image(systemName: "xmark.circle.fill")
            })
            .buttonStyle(.plain)
            .foregroundStyle(HierarchicalShapeStyle.tertiary)
        }
        .font(.system(size: 16, weight: .medium))
        .foregroundStyle(isSelected ? .white : .secondary)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .lineLimit(1)
        .background(isSelected ? AnyShapeStyle(.tint) : AnyShapeStyle(HierarchicalShapeStyle.quinary))
        .clipShape(Capsule())
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var tags: [TagViewItem] = {
           var tags = [TagViewItem]()
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .spellOut
            for number in 1...9 {
                tags.append(TagViewItem(title: numberFormatter.string(from: number as NSNumber)!.capitalized, isSelected: false))
            }
            return tags
        }()
        
        var body: some View {
            VStack {
                TagView(layout: .horizontal, tags: $tags) { tag in
                    print(tag, "remove")
                }
                
                Spacer()
                
                TagView(layout: .vertical, tags: $tags) { tag in
                    print(tag, "remove")
                }
            }
            .padding(.vertical, 100)
        }
    }
    return PreviewWrapper()
}
