//
//  DeviceColorSpace.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 19.05.2024.
//

import Foundation
import CoreGraphics.CGColorSpace

public enum ColorSpace: String, Identifiable, CaseIterable {
    case displayP3
    case sRGB
    case genericCMYK
    case genericLabLAB
    case adobeRGB1998
    case dcip3
    case itur_709
    case itur_2020
    
    public var id: String {
        self.rawValue
    }
    
    public var name: String {
        switch self {
        case .displayP3:
            "Display P3"
        case .sRGB:
            "sRGB"
        case .genericCMYK:
            "CMYK"
        case .genericLabLAB:
            "LAB"
        case .adobeRGB1998:
            "Adobe RGB (1998)"
        case .dcip3:
            "DCI P3"
        case .itur_709:
            "BT.709"
        case .itur_2020:
            "BT.2020"
        }
    }
    
    public var cgColorSpace: CGColorSpace? {
        switch self {
        case .sRGB:
            CGColorSpace(name: CGColorSpace.sRGB)
        case .displayP3:
            CGColorSpace(name: CGColorSpace.displayP3)
        case .genericCMYK:
            CGColorSpace(name: CGColorSpace.genericCMYK)
        case .genericLabLAB:
            CGColorSpace(name: CGColorSpace.genericLab)
        case .adobeRGB1998:
            CGColorSpace(name: CGColorSpace.adobeRGB1998)
        case .dcip3:
            CGColorSpace(name: CGColorSpace.dcip3)
        case .itur_709:
            CGColorSpace(name: CGColorSpace.itur_709)
        case .itur_2020:
            CGColorSpace(name: CGColorSpace.itur_2020)
        }
    }
    
    public var rgbWorkingSpace: RGBWorkingSpace? {
        switch self {
        case .displayP3, .dcip3:
            return .DisplayP3
        case .sRGB:
            return .sRGB
        case .adobeRGB1998:
            return .AdobeRGB1998
        case .itur_709:
            return .Rec709
        case .itur_2020:
            return .Rec2020
        default:
            return nil
        }
    }
    
    /// Init with DeviceRGB CGColorSpace
    static public var deviceColorSpace: Self {
        ColorSpace(cgColorSpace: CGColorSpaceCreateDeviceRGB())
    }
    
    public init(cgColorSpace: CGColorSpace) {
        switch cgColorSpace {
        case _ where cgColorSpace == CGColorSpace(name: CGColorSpace.sRGB):
            self = .sRGB
        case _ where cgColorSpace == CGColorSpace(name: CGColorSpace.displayP3):
            self = .displayP3
        case _ where cgColorSpace == CGColorSpace(name: CGColorSpace.genericCMYK):
            self = .genericCMYK
        case _ where cgColorSpace == CGColorSpace(name: CGColorSpace.genericLab):
            self = .genericLabLAB
        case _ where cgColorSpace == CGColorSpace(name: CGColorSpace.adobeRGB1998):
            self = .adobeRGB1998
        case _ where cgColorSpace == CGColorSpace(name: CGColorSpace.dcip3):
            self = .dcip3
        case _ where cgColorSpace == CGColorSpace(name: CGColorSpace.itur_709):
            self = .itur_709
        case _ where cgColorSpace == CGColorSpace(name: CGColorSpace.itur_2020):
            self = .itur_2020
        default:
            self = .sRGB
        }
    }
}
