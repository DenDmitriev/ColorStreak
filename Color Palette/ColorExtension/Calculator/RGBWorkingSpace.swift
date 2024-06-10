//
//  RGBWorkingSpace.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 18.05.2024.
//

import Foundation
import simd

/// RGB Working Space Matrices
/// [RGB/XYZ Matrices](http://www.brucelindbloom.com/index.html?Eqn_RGB_XYZ_Matrix.html)
public enum RGBWorkingSpace: String, CaseIterable, Identifiable {
    case AdobeRGB1998 = "Adobe RGB (1998)"
    case AppleRGB = "AppleRGB"
    case BestRGB = "Best RGB"
    case BetaRGB = "Beta RGB"
    case BruceRGB = "Bruce RGB"
    case CIERGB = "CIE RGB"
    case ColorMatchRGB = "ColorMatch RGB"
    case DonRGB4 = "Don RGB 4"
    case ECIRGB = "ECI RGB"
    case EktaSpacePS5 = "Ekta Space PS5"
    case NTSCRGB = "NTSC RGB"
    case PALSECAMRGB = "PAL/SECAM RGB"
    case ProPhotoRGB = "ProPhoto RGB"
    case SMPTECRGB = "SMPTE-C RGB"
    case sRGB = "sRGB"
    case WideGamutRGB = "Wide Gamut RGB"
    case DisplayP3 = "Display P3"
    case Rec709 = "Rec. 709"
    case Rec2020 = "Rec. 2020"
    
    public var id: String {
        self.rawValue
    }
    
    public var referenceWhite: ReferenceWhite {
        switch self {
        case .AdobeRGB1998:
                .D65
        case .AppleRGB:
                .D65
        case .BestRGB:
                .D50
        case .BetaRGB:
                .D50
        case .BruceRGB:
                .D65
        case .CIERGB:
                .E
        case .ColorMatchRGB:
                .D50
        case .DonRGB4:
                .D50
        case .ECIRGB:
                .D50
        case .EktaSpacePS5:
                .D50
        case .NTSCRGB:
                .C
        case .PALSECAMRGB:
                .D65
        case .ProPhotoRGB:
                .D50
        case .SMPTECRGB:
                .D65
        case .sRGB:
                .D65
        case .WideGamutRGB:
                .D50
        case .DisplayP3:
                .D65
        case .Rec709:
                .D65
        case .Rec2020:
                .D65
        }
    }
    
    /// RGB to XYZ [M]
    public var RGBtoXYZ: simd_double3x3 {
        switch self {
        case .AdobeRGB1998:
            simd_double3x3([[0.5767309, 0.1855540, 0.1881852], [0.2973769, 0.6273491, 0.0752741], [0.0270343, 0.0706872, 0.9911085]])
        case .AppleRGB:
            simd_double3x3([[0.4497288, 0.3162486, 0.1844926], [0.2446525, 0.6720283, 0.0833192], [0.0251848, 0.1411824, 0.9224628]])
        case .BestRGB:
            simd_double3x3([[0.6326696, 0.2045558, 0.1269946], [0.2284569, 0.7373523, 0.0341908], [0.0000000, 0.0095142, 0.8156958]])
        case .BetaRGB:
            simd_double3x3([[0.6712537, 0.1745834, 0.1183829], [0.3032726, 0.6637861, 0.0329413], [0.0000000, 0.0407010, 0.7845090]])
        case .BruceRGB:
            simd_double3x3([[0.4674162, 0.2944512, 0.1886026], [0.2410115, 0.6835475, 0.0754410], [0.0219101, 0.0736128, 0.9933071]])
        case .CIERGB:
            simd_double3x3([[0.4887180, 0.3106803, 0.2006017], [0.1762044, 0.8129847, 0.0108109], [0.0000000, 0.0102048, 0.9897952]])
        case .ColorMatchRGB:
            simd_double3x3([[0.5093439, 0.3209071, 0.1339691], [0.2748840, 0.6581315, 0.0669845], [0.0242545, 0.1087821, 0.6921735]])
        case .DonRGB4:
            simd_double3x3([[0.6457711, 0.1933511, 0.1250978], [0.2783496, 0.6879702, 0.0336802], [0.0037113, 0.0179861, 0.8035125]])
        case .ECIRGB:
            simd_double3x3([[0.6502043, 0.1780774, 0.1359384], [0.3202499, 0.6020711, 0.0776791], [0.0000000, 0.0678390, 0.7573710]])
        case .EktaSpacePS5:
            simd_double3x3([[0.5938914, 0.2729801, 0.0973485], [0.2606286, 0.7349465, 0.0044249], [0.0000000, 0.0419969, 0.7832131]])
        case .NTSCRGB:
            simd_double3x3([[0.6068909, 0.1735011, 0.2003480], [0.2989164, 0.5865990, 0.1144845], [0.0000000, 0.0660957, 1.1162243]])
        case .PALSECAMRGB:
            simd_double3x3([[0.4306190, 0.3415419, 0.1783091], [0.2220379, 0.7066384, 0.0713236], [0.0201853, 0.1295504, 0.9390944]])
        case .ProPhotoRGB:
            simd_double3x3([[0.7976749, 0.1351917, 0.0313534], [0.2880402, 0.7118741, 0.0000857], [0.0000000, 0.0000000, 0.8252100]])
        case .SMPTECRGB:
            simd_double3x3([[0.3935891, 0.3652497, 0.1916313], [0.2124132, 0.7010437, 0.0865432], [0.0187423, 0.1119313, 0.9581563]])
        case .sRGB:
            simd_double3x3([[0.4124564, 0.3575761, 0.1804375], [0.2126729, 0.7151522, 0.0721750], [0.0193339, 0.1191920, 0.9503041]])
        case .WideGamutRGB:
            simd_double3x3([[0.7161046, 0.1009296, 0.1471858], [0.2581874, 0.7249378, 0.0168748], [0.0000000, 0.0517813, 0.7734287]])
        case .DisplayP3:
            simd_double3x3([0.48663265, 0.2656631625, 0.1981741875], [0.2290036, 0.691726725, 0.079269675], [0, 0.0451126125, 1.0437173875])
        case .Rec709:
            RGBWorkingSpace.sRGB.RGBtoXYZ
        case .Rec2020:
            simd_double3x3([[0.6369535, 0.1446192, 0.1688559], [0.2626983, 0.6780088, 0.0592929], [0.0000000, 0.0280731, 1.0608272]])
        }
    }
    
    /// XYZ to RGB [M]-1
    public var XYZtoRGB: simd_double3x3 {
        switch self {
        case .AdobeRGB1998:
            simd_double3x3([[2.0413690, -0.5649464, -0.3446944], [-0.9692660, 1.8760108, 0.0415560], [0.0134474, -0.1183897, 1.0154096]])
        case .AppleRGB:
            simd_double3x3([[2.9515373, -1.2894116, -0.4738445], [-1.0851093, 1.9908566, 0.0372026], [0.0854934, -0.2694964, 1.0912975]])
        case .BestRGB:
            simd_double3x3([[1.7552599, -0.4836786, -0.2530000], [-0.5441336, 1.5068789, 0.0215528], [0.0063467, -0.0175761, 1.2256959]])
        case .BetaRGB:
            simd_double3x3([[1.6832270, -0.4282363, -0.2360185], [-0.7710229, 1.7065571, 0.0446900], [0.0400013, -0.0885376, 1.2723640]])
        case .BruceRGB:
            simd_double3x3([[2.7454669, -1.1358136, -0.4350269], [-0.9692660, 1.8760108, 0.0415560], [0.0112723, -0.1139754, 1.0132541]])
        case .CIERGB:
            simd_double3x3([[2.3706743, -0.9000405, -0.4706338], [-0.5138850, 1.4253036, 0.0885814], [0.0052982, -0.0146949, 1.0093968]])
        case .ColorMatchRGB:
            simd_double3x3([[2.6422874, -1.2234270, -0.3930143], [-1.1119763, 2.0590183, 0.0159614], [0.0821699, -0.2807254, 1.4559877]])
        case .DonRGB4:
            simd_double3x3([[1.7603902, -0.4881198, -0.2536126], [-0.7126288, 1.6527432, 0.0416715], [0.0078207, -0.0347411, 1.2447743]])
        case .ECIRGB:
            simd_double3x3([[1.7827618, -0.4969847, -0.2690101], [-0.9593623, 1.9477962, 0.0275807], [0.0859317, -0.1744674, 1.3228273]])
        case .EktaSpacePS5:
            simd_double3x3([[2.0043819, -0.7304844, -0.2450052], [-0.7110285, 1.6202126, 0.0792227], [0.0381263, -0.0868780, 1.2725438]])
        case .NTSCRGB:
            simd_double3x3([[1.9099961, -0.5324542, -0.2882091], [-0.9846663, 1.9991710, 0.0283082], [0.0583056, -0.1183781, 0.8975535]])
        case .PALSECAMRGB:
            simd_double3x3([[3.0628971, -1.3931791, -0.4757517], [-0.9692660, 1.8760108, 0.0415560], [0.0678775, -0.2288548, 1.0693490]])
        case .ProPhotoRGB:
            simd_double3x3([[1.3459433, -0.2556075, -0.0511118], [-0.5445989, 1.5081673, 0.0205351], [0.0000000,  0.0000000, 1.2118128]])
        case .SMPTECRGB:
            simd_double3x3([[3.5053960, -1.7394894, -0.5439640], [-1.0690722, 1.9778245, 0.0351722], [0.0563200, -0.1970226, 1.0502026]])
        case .sRGB:
            simd_double3x3([[3.2404542, -1.5371385, -0.4985314], [-0.9692660, 1.8760108, 0.0415560], [0.0556434, -0.2040259, 1.0572252]])
        case .WideGamutRGB:
            simd_double3x3([[1.4628067, -0.1840623, -0.2743606], [-0.5217933, 1.4472381, 0.0677227], [0.0349342, -0.0968930, 1.2884099]])
        case .DisplayP3:
            simd_double3x3([[2.4931807553289667, -0.9312655254971397, -0.4026597237588816], [-0.8295031158210787, 1.7626941211197922, 0.0236250887417396], [0.0358536257800717, -0.0761889547826522, 0.9570926215180212]])
        case .Rec709:
            RGBWorkingSpace.sRGB.XYZtoRGB
        case .Rec2020:
            simd_double3x3([[1.71666343, -0.35567332, -0.25336809], [-0.66667384, 1.61645574, 0.0157683 ], [0.01764248, -0.04277698, 0.94224328]])
        }
    }
    
    public var gamma: Double {
        switch self {
        case .AdobeRGB1998:
            2.2
        case .AppleRGB:
            1.8
        case .BestRGB:
            2.2
        case .BetaRGB:
            2.2
        case .BruceRGB:
            2.2
        case .CIERGB:
            2.2
        case .ColorMatchRGB:
            1.8
        case .DonRGB4:
            2.2
        case .ECIRGB:
            1.8
        case .EktaSpacePS5:
            2.2
        case .NTSCRGB:
            2.2
        case .PALSECAMRGB:
            2.2
        case .ProPhotoRGB:
            1.8
        case .SMPTECRGB:
            2.2
        case .sRGB:
            2.2
        case .WideGamutRGB:
            2.2
        case .DisplayP3:
            2.2
        case .Rec709:
            2.2
        case .Rec2020:
            2.2
        }
    }
}
