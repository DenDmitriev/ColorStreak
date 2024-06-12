//
//  SuggestedTagsSectionView.swift
//  Color Palette
//
//  Created by Denis Dmitriev on 12.06.2024.
//

import SwiftUI

struct SuggestedTagsSectionView: View {
    
    @Binding var tags: [ColorHunterTag]
    let action: (ColorHunterTag) -> Void
    
    @State private var size: CGSize = .zero
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ForEach(ColorHunterTag.Kind.allCases) { kind in
                    VStack(spacing: 8) {
                        Text(kind.name)
                            .font(.title2.weight(.semibold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        var bindingTags: Binding<[ColorHunterTag]> {
                            Binding(get: {
                                tags.filter({ $0.kind == kind })
                            }, set: { _ in })
                        }
                        SuggestedTagsView(tags: bindingTags, action: action)
                    }
                }
            }
            .readSize { size in
                self.size = size
            }
        }
        .frame(height: size.height)
    }
}

#Preview {
    SuggestedTagsSectionView(tags: .constant(ColorHunterTag.allCases), action: { print($0.name) })
}
