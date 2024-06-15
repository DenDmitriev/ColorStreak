//
//  NewImageColors.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 04.06.2024.
//

import SwiftUI
import PhotosUI
import DominantColors
import FirebaseCrashlytics

struct NewImageColors: View {
    @ObservedObject var palette: Palette
    @State private var count: Double = 5
    @State var imageSelection: PhotosPickerItem?
    @State private(set) var imageState: ImageState = .empty
    
    var body: some View {
        Section {
            PhotosPicker(selection: $imageSelection, matching: .images, photoLibrary: .shared()) {
                HStack {
                    Text("Select image")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .tint(.primary)
                    
                    Image(systemName: "photo.fill")
                        .font(.system(size: 30))
                }
            }
            .onChange(of: imageSelection) { _, imageSelection in
                if let imageSelection {
                    let progress = loadTransferable(from: imageSelection)
                    imageState = .loading(progress)
                } else {
                    imageState = .empty
                }
            }
            
            HStack(spacing: 16) {
                Text("Colors")
                Slider(value: $count, in: 1...12, step: 1) { changed in
                    if case .success(let image) = imageState {
                        Task(priority: .userInitiated) {
                            await self.getColors(image: image)
                        }
                    }
                }
                Text(count, format: .number)
            }
            
            Group {
                switch imageState {
                case .success(let image):
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 300)
                        .onAppear {
                            palette.image =  image
                        }
                        .task {
                            await getColors(image: image)
                        }
                case .loading:
                    ProgressView()
                case .empty:
                    Text("No Image")
                        .font(.headline)
                        .foregroundStyle(HierarchicalShapeStyle.quinary)
                        .multilineTextAlignment(.center)
                case .failure:
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, -22)
            .padding(.vertical, -12)
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
    private func getColors(image: UIImage) async {
        Task(priority: .userInitiated) {
            do {
                let colors = try image.dominantColors(max: Int(count), options: [.excludeBlack, .excludeWhite])
                DispatchQueue.main.async {
                    self.palette.colors = colors.map({ Color($0) })
                }
            } catch {
                print(error.localizedDescription)
                sendLogMessageCrashlytics(error: error, function: #function)
            }
        }
    }
    
    enum ImageState {
        case empty
        case loading(Progress)
        case success(UIImage)
        case failure(Error)
    }
    
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: PaletteImage.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else {
                    print("Failed to get the selected item.")
                    return
                }
                switch result {
                case .success(let paletteImage?):
                    self.imageState = .success(paletteImage.image)
                case .success(nil):
                    self.imageState = .empty
                case .failure(let error):
                    self.imageState = .failure(error)
                }
            }
        }
    }
    
    struct PaletteImage: Transferable {
        let image: UIImage
        
        enum TransferError: Error {
            case importFailed, resizeError
        }
        
        static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .image) { data in
            #if canImport(AppKit)
                guard let nsImage = NSImage(data: data) else {
                    throw TransferError.importFailed
                }
                let image = Image(nsImage: nsImage)
                return ProfileImage(image: image)
            #elseif canImport(UIKit)
                guard let uiImage = UIImage(data: data)?.fixedOrientation
//                      let convertedUIImage = uiImage.convert()
                else {
                    throw TransferError.importFailed
                }
                
                if UIScreen.screenWidth < uiImage.size.width {
                    let width = UIScreen.screenWidth
                    guard let resizedImage = uiImage.resizeImage(width: width) else {
                        throw TransferError.resizeError
                    }
                    
                    return PaletteImage(image: resizedImage)
                } else {
                    return PaletteImage(image: uiImage)
                }
            #else
                throw TransferError.importFailed
            #endif
            }
        }
    }
    
    private func sendLogMessageCrashlytics(error: Error, function: String) {
        Crashlytics.crashlytics().log("Palette From Image: \(error.localizedDescription), \(function)")
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var palette: Palette = .init()
        
        var body: some View {
            List {
                NewImageColors(palette: palette)
                
                HStack {
                    ForEach(palette.colors, id: \.self) { color in
                        Rectangle()
                            .fill(color)
                    }
                }
                .frame(height: 50)
            }
        }
    }
    
    return PreviewWrapper()
}
