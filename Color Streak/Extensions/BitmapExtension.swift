//
//  BitMapExtension.swift
//  Color Streak
//
//  Created by Denis Dmitriev on 14.06.2024.
//

import CoreGraphics

public extension CGBitmapInfo {
    
    enum ComponentLayout {
        case a
        case bgra
        case abgr
        case argb
        case rgba
        case bgr
        case rgb
        
        var count: Int {
            switch self {
            case .a: return 1
            case .bgr, .rgb: return 3
            default: return 4
            }
        }
    }
    
    var componentLayout: ComponentLayout? {
        guard let alphaInfo = CGImageAlphaInfo(rawValue: rawValue & Self.alphaInfoMask.rawValue) else { return nil }
        let isLittleEndian = contains(.byteOrder32Little)

        if alphaInfo == .none {
            return isLittleEndian ? .bgr : .rgb
        }
        let alphaIsFirst = alphaInfo == .premultipliedFirst || alphaInfo == .first || alphaInfo == .noneSkipFirst

        if isLittleEndian {
            return alphaIsFirst ? .bgra : .abgr
        } else {
            return alphaIsFirst ? .argb : .rgba
        }
    }
    
    var isAlphaPremultiplied: Bool {
        let alphaInfo = CGImageAlphaInfo(rawValue: rawValue & Self.alphaInfoMask.rawValue)
        return alphaInfo == .premultipliedFirst || alphaInfo == .premultipliedLast
    }
}
