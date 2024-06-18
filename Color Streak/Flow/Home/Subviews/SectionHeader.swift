//
//  SectionHeader.swift
//  Color Streak
//
//  Created by Denis Dmitriev on 17.06.2024.
//

import SwiftUI

struct SectionHeader: View {
    
    @State var title: String
    var budge: BudgeView.Kind? = nil
    var action: (() -> Void)?
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            HStack {
                if !title.isEmpty {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                } else {
                    ShimmerEffectView()
                        .cornerRadius(8)
                        .frame(width: 128)
                }
                
                if let budge {
                    BudgeView(kind: budge)
                        
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            if let action, !title.isEmpty {
                Button("See all") {
                    action()
                }
            } else if action != nil {
                ShimmerEffectView(style: .custom(colors: [.primary.opacity(0.5)]), animation: false)
                    .clipShape(Capsule())
                    .frame(width: 64)
            }
        }
        .frame(height: 29)
    }
}

#Preview {
    VStack {
        SectionHeader(title: "Palette", budge: .new, action: { print("See all did taped") })
        SectionHeader(title: "", action: { print("See all did taped") })
        SectionHeader(title: "")
    }
}

