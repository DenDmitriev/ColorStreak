//
//  BudgeView.swift
//  Color Streak
//
//  Created by Denis Dmitriev on 14.06.2024.
//

import SwiftUI

struct BudgeView: View {
    let kind: Kind
    
    enum Kind {
        case new, custom(text: String, color: Color)
        
        var color: Color {
            switch self {
            case .new:
                return .green
            case .custom(_, let color):
                return color
            }
        }
        
        var title: String {
            switch self {
            case .new:
                return String(localized: "New")
            case .custom(text: let text, _):
                return text
            }
        }
    }
    
    var body: some View {
        Text(kind.title)
            .foregroundStyle(kind.color)
            .font(.caption2.weight(.semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background {
                RoundedRectangle(cornerRadius: 4)
                    .fill(.regularMaterial)
            }
            .background {
                RoundedRectangle(cornerRadius: 4)
                    .fill(kind.color.opacity(0.5))
            }
    }
}

#Preview {
    BudgeView(kind: .new)
}
