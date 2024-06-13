//
//  DeviceColorSpace.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 27.05.2024.
//

import CoreGraphics.CGColorSpace
import SwiftUI

public enum DeviceColorSpace: Int, Identifiable, CaseIterable {
    case sRGB
    case displayP3

    public var id: Int {
        self.rawValue
    }
    
    public var name: String {
        switch self {
        case .displayP3:
            "Display P3"
        case .sRGB:
            "sRGB"
        }
    }
    
    var colorSpace: ColorSpace {
        switch self {
        case .displayP3:
            return .displayP3
        case .sRGB:
            return .sRGB
        }
    }
    
    var cgColorSpace: CGColorSpace {
        switch self {
        case .displayP3:
            CGColorSpace(name: CGColorSpace.displayP3) ?? CGColorSpaceCreateDeviceRGB()
        case .sRGB:
            CGColorSpace(name: CGColorSpace.sRGB) ?? CGColorSpaceCreateDeviceRGB()
        }
    }
    
    var rgbColorSpace: Color.RGBColorSpace {
        switch self {
        case .displayP3:
            return .displayP3
        case .sRGB:
            return .sRGB
        }
    }
    
    var rgbWorkingSpace: RGBWorkingSpace {
        switch self {
        case .displayP3:
            return .DisplayP3
        case .sRGB:
            return .sRGB
        }
    }
}
