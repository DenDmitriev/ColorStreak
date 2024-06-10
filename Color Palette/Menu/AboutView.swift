//
//  AboutView.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 05.06.2024.
//

import SwiftUI
import StoreKit

struct AboutView: View {
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    let appBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    let mailSupport = URL(string: "mailto:some@mail.com")
    
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        List {
            Section {
                HStack(spacing: 16) {
                    Circle()
                        .fill(.secondary)
                        .frame(width: 100)
                        .aspectRatio(1.0, contentMode: .fit)
                    
                    VStack(alignment: .leading) {
                        Text("Color Palette")
                            .font(.title)
                        Text("Version \(appVersion ?? "Empty") (Build \(appBuild ?? "Empty"))")
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Link(destination: URL(string: "https://www.apple.com")!, label: {
                    Text("Private Policy")
                })
            }
            
            Section {
                Link("Email Support", destination: mailSupport!)
                
                Button("Review in App Store") {
                    requestReview()
                }
            }
        }
        .foregroundStyle(.primary)
        .navigationTitle("About")
    }
}

#Preview {
    AboutView()
}
