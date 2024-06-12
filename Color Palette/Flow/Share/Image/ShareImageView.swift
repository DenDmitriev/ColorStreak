//
//  ShareImageView.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 03.06.2024.
//

import SwiftUI

struct ShareImageView: View {
    enum ImageRenderState {
        case empty, rendering, rendered(uiImage: UIImage), failure(error: String)
    }
    
    @ObservedObject var palette: Palette
    @State private var state: ImageRenderState = .empty
    @State private var paletteImage: PaletteImage?
    @State private var axis: AxisPalette = .horizontal
    
    @AppStorage(UserDefaultsKey.widthPalette.key)
    private var widthPalette: Int = 500
    
    @AppStorage(UserDefaultsKey.heightPalette.key)
    private var heightPalette: Int = 500
    
    let pixelFormatter: BoundIntFormatter = {
        let formatter = BoundIntFormatter()
        formatter.max = 4096
        formatter.min = 10
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: .zero) {
            ZStack {
                Color.clear
                
                switch state {
                case .empty:
                    Text("Can't create palette image")
                        .foregroundStyle(.secondary)
                        .font(.title3)
                case .rendering:
                    ProgressView()
                case .rendered(let uiImage):
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .failure(let failure):
                    Text(failure)
                }
            }
            
            List {
                Section("Size") {
                    HStack {
                        Text("Width:")
                        TextField("Width", value: $widthPalette, formatter: pixelFormatter)
                            .frame(width: 50)
                        Text("px")
                        
                        Spacer()
                        
                        Text("Height:")
                        TextField("Height", value: $heightPalette, formatter: pixelFormatter)
                            .frame(width: 50)
                        Text("px")
                    }
                    .multilineTextAlignment(.trailing)
                }
                .keyboardType(.numberPad)
                .onSubmit {
                    createPaletteImage()
                }
                
                Section("Appearance") {
                    Picker("Axis", selection: $axis) {
                        ForEach(AxisPalette.allCases) { axis in
                            Text(axis.rawValue)
                                .tag(axis)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(.appBackground)
            .frame(height: 200)
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                shareButton
            }
        })
        .onAppear {
            createPaletteImage()
        }
        .onChange(of: axis) { _, newAxis in
            createPaletteImage()
        }
    }
    
    @ViewBuilder
    private var shareButton: some View {
        switch state {
        case .rendered(let uiImage):
            let item = PaletteImage(image: Image(uiImage: uiImage), caption: palette.name.isEmpty ? "Palette" : palette.name)
            ShareLink(item: item, preview: SharePreview(item.caption, image: item.image)) {
                Image(systemName: "square.and.arrow.up")
            }
        default:
            Image(systemName: "square.and.arrow.up")
                .foregroundStyle(.secondary)
        }
    }
    
    private func createPaletteImage() {
        guard !palette.colors.isEmpty else { return }
        
        Task(priority: .medium) {
            DispatchQueue.main.async {
                self.state = .rendering
            }
            
            let size = CGSize(width: widthPalette, height: heightPalette)
            do {
                let uiImage = try ImageRenderService.paletteImage(size: size, colors: palette.colors.map({  UIColor($0) }), axis: axis == .horizontal ? .horizontal : .vertical)
                
                DispatchQueue.main.async {
                    self.state = .rendered(uiImage: uiImage)
                }
            } catch {
                DispatchQueue.main.async {
                    self.state = .failure(error: error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ShareImageView(palette: .placeholder)
    }
}
