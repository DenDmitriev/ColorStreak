//
//  ImportImageButton.swift
//  Color Streak
//
//  Created by Denis Dmitriev on 17.06.2024.
//

import SwiftUI
import FirebaseAnalytics

struct ImportImageButton: View {
    @EnvironmentObject private var coordinator: Coordinator<HomeRouter, HomeError>
    
    @AppStorage(UserDefaultsKey.colorSource.key)
    private var colorSource: ColorSource = .harmony
    
    var body: some View {
        Button(action: {
            colorSource = .image
            coordinator.present(sheet: .newPalette)
            analyticsSendLog()
        }, label: {
            Label("Palette from image", systemImage: "photo.fill")
                .foregroundStyle(.white)
                .font(.system(size: 20, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background {
                    Capsule()
                        .fill(LinearGradient(colors: [.appPink, .appPinkLight], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .overlay {
                            LinearGradient(colors: [.appBlueDark, .clear], startPoint: .bottom, endPoint: .top)
                                .blendMode(.overlay)
                                .clipShape(Capsule())
                        }
                }
        })
    }
    
    private func analyticsSendLog() {
        Analytics.logEvent(AnalyticsEvent.createImagePalette.key, parameters: [AnalyticsParameterSource: "\(type(of: self))"])
    }
}

#Preview {
    ImportImageButton()
}
