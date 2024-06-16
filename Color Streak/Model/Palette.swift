//
//  Palette.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 27.05.2024.
//

import SwiftUI
import Combine

class Palette: ObservableObject, Copyable {
    @Published var colors = [Color]()
    @Published var selection: Int?
    @Published var colorSpace: DeviceColorSpace = .sRGB
    @Published var name: String = ""
    @Published var tags: [ColorTag] = []
    @Published var isNew = false
    var dateCreated: Date
    var dateModified: Date
    var image: UIImage?
    
    var cancellable = Set<AnyCancellable>()
    
    var id: UUID = UUID()
    
    init() {
        dateCreated = Date.now
        dateModified = Date.now
    }
    
    convenience init(colors: [Color] = [Color](), name: String = "", colorSpace: DeviceColorSpace = .displayP3, image: UIImage? = nil, tags: [ColorTag] = []) {
        self.init()
        self.colors = colors
        self.colorSpace = colorSpace
        self.name = name
        self.image = image
        self.tags = tags
        self.selection = colors.first != nil ? .zero : nil
    }
    
    convenience init(hexs: [String], name: String, colorSpace: DeviceColorSpace = .sRGB) {
        self.init()
        self.colors = hexs.compactMap({ hex in
            Color(hex: hex)
        })
        self.colorSpace = colorSpace
        self.name = name
        self.selection = colors.first != nil ? .zero : nil
    }
    
    required init(copy: Palette) {
        self.colors = copy.colors
        self.name = "Copy of " + copy.name
        self.colorSpace = copy.colorSpace
        self.image = copy.image
        self.tags = copy.tags
        self.dateCreated = Date.now
        self.dateModified = Date.now
    }
    
    var isMaxColors: Bool {
        colors.count >= 12
    }
    
    var isEmptyColors: Bool {
        colors.isEmpty
    }
    
    var searchText: String {
        var total = [String]()
        total.append(name)
        total.append(contentsOf: tags.map({ $0.tag }))
        
        return total.joined(separator: " ")
    }
    
    func saveModel() {
        dateModified = Date.now
        Task(priority: .background) {
            try await CoreDataManager.shared.updatePalette(palette: self)
        }
    }
    
    func convert(device colorSpace: DeviceColorSpace) {
        colors = colors.map { color in
            if color.cgColorSpace != colorSpace.cgColorSpace {
                return color.converted(cgColorSpace: colorSpace.cgColorSpace)
            } else {
                return color
            }
        }
    }
    
    func convert(global colorSpace: ColorSpace) {
        colors = colors.map { color in
            if color.cgColorSpace != colorSpace.cgColorSpace {
                return color.converted(colorSpace: colorSpace)
            } else {
                return color
            }
        }
    }
    
    func removeColorSelection() {
        guard let selection, !isEmptyColors else { return }
        switch selection {
        case 0:
            if colors.count > 1 {
                
            } else {
                self.selection = nil
            }
            colors.remove(at: selection)
        case (colors.count - 1):
            if colors.count > 1 {
                let index = colors.index(before: selection)
                self.selection = index
                
            } else {
                self.selection = nil
            }
            colors.remove(at: selection)
        default:
            if 0..<colors.count ~= selection {
                
            } else {
                self.selection = nil
            }
            colors.remove(at: selection)
        }
    }
    
    func appendColor(colorSpace: Color.RGBColorSpace) {
        guard !isMaxColors else { return }
        
        if colors.isEmpty {
            colors.append(Color(colorSpace, red: 1, green: 0, blue: 0))
        } else if let selection {
            let selectedColor = colors[selection].hsb
            let hueDegrees: Double = selectedColor.hue360 + Double(360 / 12)
            let hue = hueDegrees.normalizedDegrees() / 360
            let saturation = selectedColor.saturation
            let brightness = selectedColor.brightness
            
            colors.append(Color(hue: hue, saturation: saturation, brightness: brightness))
        } else {
            let hue = Double(Int.random(in: 0...360)) / 360
            let saturation = Double(Int.random(in: 50...100)) / 100
            let brightness = Double(Int.random(in: 50...100)) / 100
            
            colors.append(Color(hue: hue, saturation: saturation, brightness: brightness))
        }
        selection = colors.count - 1
    }
    
    func generateName() -> String? {
        if let keyColor = colors.first {
            let colorShade = ColorShade(cgColor: UIColor(keyColor).cgColor)
            return colorShade.title.capitalized
        } else {
            return nil
        }
    }
    
    func autoTags() {
        for color in colors {
            let shade = ColorShade(cgColor: UIColor(color).cgColor)
            guard !tags.contains(where: { $0.tag == shade.title }) else { continue }
            tags.append(ColorTag(tag: shade.title))
        }
    }
    
    func append(tag: String) {
        guard 3...9 ~= tag.count,
              !tags.contains(where: { $0.tag == tag })
        else { return }
        
        DispatchQueue.main.async {
            self.tags.append(ColorTag(tag: tag))
        }
    }
    
    func remove(tag: String) {
        DispatchQueue.main.async {
            self.tags.removeAll(where: { $0.tag == tag })
        }
    }
}

extension Palette: Identifiable, Hashable {
    static func == (lhs: Palette, rhs: Palette) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Palette {
    static var placeholder: Palette = {
        let palette = Palette(
            colors: [.red, .orange, .yellow, .green, .cyan, .blue, .purple],
            name: "Palette",
            image: UIImage(named: "Palette"),
            tags: [ColorTag(tag: "Rainbow")]
        )
        palette.isNew = true
        
        return palette
    }()
    
    static let rgb = Palette(
        colors: [
            Color(red: 1, green: 0, blue: 0),
            Color(red: 0, green: 1, blue: 0),
            Color(red: 0, green: 0, blue: 1)
                ],
        name: "RGB",
        image: UIImage(resource: .rgb300X100))
    
    static let circleImages = Palette(
        colors: [
            Color(hex: "E02020") ?? .clear,
            Color(hex: "F7B500") ?? .clear,
            Color(hex: "6DD400") ?? .clear,
            Color(hex: "32C5FF") ?? .clear,
            Color(hex: "6236FF") ?? .clear
                ],
        name: "RGB",
        image: UIImage(resource: .circleColors))
    
    static func single(_ color: Color) -> Palette { Palette(colors: [color]) }
}

extension Palette {
    func css() -> String {
        /* Color Theme Swatches in Hex */
        // .My-Color-Theme-1-hex { color: #C03EFA; }
        var css: String = "/* Color Theme Swatches in Hex */\n"
        let name = ".\(name.replacingOccurrences(of: " ", with: "-"))-hex"
        for color in colors {
            css.append("\(name) { color: #\(color.hex); }\n")
        }
        
        return css
    }
    
    func xml() -> String {
        // <palette>
        // <color name='My-Color-Theme-1' rgb='C03EFA' r='192' g='62' b='250' />
        // </palette>
        var xml: String = "<palette>\n"
        let name = "\(name.replacingOccurrences(of: " ", with: "-"))"
        for color in colors {
            let rgb = color.rgb
            xml.append("<color name='\(name)' rgb='\(color.hex)' r='\(rgb.red255)' g='\(rgb.green255)' b='\(rgb.blue255)' />\n")
        }
        xml.append("</palette>")
        
        return xml
    }
}
