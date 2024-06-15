//
//  DetailPaletteView.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 03.06.2024.
//

import SwiftUI
import Combine
import FirebaseAnalytics

struct DetailPaletteView: View {
    @ObservedObject var palette: Palette
    @State private var tagText: String = ""
    @Environment(\.dismiss) var dismiss
    
    private let nameMaxChars = 12
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("", text: $palette.name,
                              prompt: Text("Palette name")
                        .foregroundStyle(.secondary)
                    )
                    .onReceive(Just(palette.name)) { _ in 
                        limitName(nameMaxChars)
                    }
                    
                    Picker("Color Space", selection: $palette.colorSpace) {
                        ForEach(DeviceColorSpace.allCases) { colorSpace in
                            Text(colorSpace.name)
                                .tag(colorSpace)
                        }
                    }
                } header: {
                    Text("General")
                } footer: {
                    Text("The name must be no more than 12 characters long.")
                }
                
                
                Section {
                    TextField("Tag", text: $tagText, prompt: Text("Tag").foregroundStyle(.secondary))
                        .onSubmit {
                            palette.append(tag: tagText)
                            tagText.removeAll()
                        }
                    
                    TagView(layout: .vertical, tags: tagsBinding) { tag in
                        palette.remove(tag: tag)
                    }
                } header: {
                    Text("Tags")
                } footer: {
                    Text("Tag length must be from 3 to 9 characters.")
                }
                
                Section("Date") {
                    HStack {
                        Text("Created:")
                        Text(palette.dateCreated, style: .date)
                        Text(palette.dateCreated, style: .time)
                    }
                    HStack {
                        Text("Modified:")
                        Text(palette.dateModified, style: .date)
                        Text(palette.dateModified, style: .time)
                    }
                }
                .foregroundStyle(.secondary)
            }
            .scrollDismissesKeyboard(.immediately)
            .scrollContentBackground(.hidden)
            .background(.appBackground)
            .navigationTitle("Detail")
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close", systemImage: "xmark.circle.fill") {
                        dismiss()
                    }
                    .tint(.secondary)
                }
            })
        }
        .onReceive(palette.$colorSpace) { newColorSpace in
            palette.convert(device: newColorSpace)
        }
        .onAppear {
            UITextField.appearance().clearButtonMode = .whileEditing
        }
        .onDisappear {
            palette.saveModel()
        }
        .analyticsScreen(name: AnalyticsEvent.screen(view: "\(type(of: self))"))
    }
    
    private var tagsBinding: Binding<[TagViewItem]> {
        Binding(
            get: { palette.tags.map({ TagViewItem(title: $0.tag, isSelected: false) }) },
            set: { _ in }
        )
    }
    
    private func limitName(_ upper: Int) {
        if palette.name.count > upper {
            palette.name = String(palette.name.prefix(upper))
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @StateObject var palette: Palette = .placeholder
        
        var body: some View {
            DetailPaletteView(palette: palette)
        }
    }
    
    return PreviewWrapper()
}
