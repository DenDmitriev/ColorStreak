//
//  PaletteAddHomeItemView.swift
//  Color Streak
//
//  Created by Denis Dmitriev on 18.06.2024.
//

import SwiftUI
import FirebaseAnalytics

struct PaletteAddHomeItemView: View {
    @EnvironmentObject private var coordinator: Coordinator<HomeRouter, HomeError>
    
    var body: some View {
        Button {
            coordinator.present(sheet: .newPalette)
            analyticsSendLog()
        } label: {
            RoundedRectangle(cornerRadius: 12)
                .fill(.appPinkLight)
                .overlay(content: {
                    Image(systemName: "plus.circle.fill")
                        .font(.largeTitle)
                })
                .foregroundStyle(.accent)
        }
        .frame(width: 100, height: 100)
        
    }
    
    private func analyticsSendLog() {
        Analytics.logEvent(AnalyticsEvent.createPalette.key, parameters: [AnalyticsParameterSource: "\(type(of: self))"])
    }
}

#Preview {
    PaletteAddHomeItemView()
}
