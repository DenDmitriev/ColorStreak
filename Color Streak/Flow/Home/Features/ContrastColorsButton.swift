//
//  ContrastColorsButton.swift
//  Color Streak
//
//  Created by Denis Dmitriev on 18.06.2024.
//

import SwiftUI
import FirebaseAnalytics

struct ContrastColorsButton: View {
    @EnvironmentObject private var coordinator: Coordinator<HomeRouter, HomeError>
    @State private var color: Color = .appPink
    private let height: CGFloat = 120
    @StateObject private var paletteContrast = Palette(colors: [Color(UIColor.darkGray), Color(UIColor.lightGray)], name: "Contrast")
    
    var body: some View {
        Button {
            coordinator.push(.contrast(paletteContrast))
            analyticsSendLog()
        } label: {
            RoundedRectangle(cornerRadius: 24)
                .fill(LinearGradient(colors: [.appBlueDark, .accent], startPoint: .bottomLeading, endPoint: .topTrailing))
                .overlay {
                    LinearGradient(colors: [.appPinkLight, .clear], startPoint: .bottom, endPoint: .top)
                        .blendMode(.overlay)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                }
                .overlay {
                    CloudedMetaBallView(color: $color)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .allowsHitTesting(false)
                }
                .overlay {
                    HStack {
                        Image(systemName: "square.fill.on.circle.fill")
                            .symbolRenderingMode(.palette)
                                .foregroundStyle(.appPinkLight, .accent)
                                .font(.system(size: 28, weight: .semibold))
                        
                        Text("Contrast Checker")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                }
        }
        .frame(height: height)
    }
    
    private func analyticsSendLog() {
        Analytics.logEvent(AnalyticsEvent.contrastChecker.key, parameters: [AnalyticsParameterSource: "\(type(of: self))"])
    }
}

#Preview {
    ContrastColorsButton()
        .environmentObject(Coordinator<HomeRouter, HomeError>())
}
