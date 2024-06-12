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
    let mailSupport = URL(string: "mailto:dv.denstr@gmail.com")
    let icons = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any]
    
    let site = URL(string: "https://dendmitriev.github.io/ColorPalette/")
    let privatePlicy = URL(string: "https://www.apple.com")
    
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        List {
            Section {
                HStack(spacing: 16) {
                    AppIcon()
                        .aspectRatio(1.0, contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    VStack(alignment: .leading) {
                        Text("Color Palette")
                            .font(.title)
                        Text("Version \(appVersion ?? "Empty") (Build \(appBuild ?? "Empty"))")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Link(destination: site!, label: {
                    Text("Site")
                })
                
                Link(destination: privatePlicy!, label: {
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
