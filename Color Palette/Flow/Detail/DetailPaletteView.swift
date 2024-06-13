//
//  DetailPaletteView.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 03.06.2024.
//

import SwiftUI

struct DetailPaletteView: View {
    @ObservedObject var palette: Palette
    @State private var tagText: String = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section("General") {
                    TextField("", text: $palette.name,
                              prompt: Text("Palette name")
                        .foregroundStyle(.secondary)
                    )
                    
                    Picker("Color Space", selection: $palette.colorSpace) {
                        ForEach(DeviceColorSpace.allCases) { colorSpace in
                            Text(colorSpace.name)
                                .tag(colorSpace)
                        }
                    }
                }
                
                Section("Tags") {
                    TextField("Tag", text: $tagText, prompt: Text("Tag").foregroundStyle(.secondary))
                        .onSubmit {
                            palette.append(tag: tagText)
                            tagText.removeAll()
                        }
                    
                    TagView(layout: .vertical, tags: tagsBinding) { tag in
                        palette.remove(tag: tag)
                    }
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
        .onDisappear {
            palette.saveModel()
        }
    }
    
    var tagsBinding: Binding<[TagViewItem]> {
        Binding(
            get: { palette.tags.map({ TagViewItem(title: $0.tag, isSelected: false) }) },
            set: { _ in }
        )
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
