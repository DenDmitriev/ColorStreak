//
//  LabCalculatorTests.swift
//  dE CalculatorTests
//
//  Created by Denis Dmitriev on 17.05.2024.
//

import XCTest
@testable import Color_Palette

final class LabCalculatorTests: XCTestCase {
    
    func testRoundConvert() {
        let pink = UIColor.systemPink.cgColor
        let rgb = RGB(red: pink.red, green: pink.green, blue: pink.blue)
        let lab: Lab = LabCalculator.convert(RGB: rgb, workingSpace: .sRGB)
        XCTAssertEqual(lab.L, 55.89, accuracy: 0.01)
        XCTAssertEqual(lab.a, 76.41, accuracy: 0.01)
        XCTAssertEqual(lab.b, 31.14, accuracy: 0.01)
        let rgbRounded = LabCalculator.convert(Lab: lab, workingSpace: .sRGB)
        XCTAssertEqual(rgbRounded.red255, 255)
        XCTAssertEqual(rgbRounded.green255, 45)
        XCTAssertEqual(rgbRounded.blue255, 85)
    }
    
    func testRGBToLabWhite() {
        let color = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        let rgb = RGB(red: color.cgColor.red, green: color.cgColor.green, blue: color.cgColor.blue)
        for space in RGBWorkingSpace.allCases {
            let lab: Lab = LabCalculator.convert(RGB: rgb, workingSpace: space)
            
            XCTAssertEqual(lab.L, 100)
            XCTAssertEqual(lab.a, 0, accuracy: 0.01)
            XCTAssertEqual(lab.b, 0, accuracy: 0.01)
        }
    }
    
    func testRGBToLabBlack() {
        let color = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        let rgb = RGB(red: color.cgColor.red, green: color.cgColor.green, blue: color.cgColor.blue)
        for space in RGBWorkingSpace.allCases {
            let lab: Lab = LabCalculator.convert(RGB: rgb, workingSpace: space)
            
            XCTAssertEqual(lab.L, 0)
            XCTAssertEqual(lab.a, 0)
            XCTAssertEqual(lab.b, 0)
        }
    }

    func testRGBToLabRed() {
        let color = UIColor.red
        let rgb = RGB(red: color.cgColor.red, green: color.cgColor.green, blue: color.cgColor.blue)
        for space in RGBWorkingSpace.allCases {
            switch space {
            case .AdobeRGB1998:
                let lab: Lab = LabCalculator.convert(RGB: rgb, workingSpace: space)
                
                XCTAssertEqual(lab.L, 61.43, accuracy: 0.01)
                XCTAssertEqual(lab.a, 89.56, accuracy: 0.01)
                XCTAssertEqual(lab.b, 75.15, accuracy: 0.01)
            case .AppleRGB:
                let lab: Lab = LabCalculator.convert(RGB: rgb, workingSpace: space)
                
                XCTAssertEqual(lab.L, 56.55, accuracy: 0.01)
                XCTAssertEqual(lab.a, 76.90, accuracy: 0.01)
                XCTAssertEqual(lab.b, 68.10, accuracy: 0.01)
            case .BestRGB:
                let lab: Lab = LabCalculator.convert(RGB: rgb, workingSpace: space)
                
                XCTAssertEqual(lab.L, 54.91, accuracy: 0.01)
                XCTAssertEqual(lab.a, 128.82, accuracy: 0.01)
                XCTAssertEqual(lab.b, 94.68, accuracy: 0.01)
            case .BetaRGB:
                let lab: Lab = LabCalculator.convert(RGB: rgb, workingSpace: space)
                
                XCTAssertEqual(lab.L, 61.94, accuracy: 0.01)
                XCTAssertEqual(lab.a, 107.21, accuracy: 0.01)
                XCTAssertEqual(lab.b, 106.79, accuracy: 0.01)
            case .BruceRGB:
                let lab: Lab = LabCalculator.convert(RGB: rgb, workingSpace: space)
                
                XCTAssertEqual(lab.L, 56.19, accuracy: 0.01)
                XCTAssertEqual(lab.a, 83.50, accuracy: 0.01)
                XCTAssertEqual(lab.b, 70.06, accuracy: 0.01)
            case .CIERGB:
                let lab: Lab = LabCalculator.convert(RGB: rgb, workingSpace: space)
                
                XCTAssertEqual(lab.L, 49.03, accuracy: 0.01)
                XCTAssertEqual(lab.a, 113.53, accuracy: 0.01)
                XCTAssertEqual(lab.b, 84.54, accuracy: 0.01)
            case .ColorMatchRGB:
                let lab: Lab = LabCalculator.convert(RGB: rgb, workingSpace: space)
                
                XCTAssertEqual(lab.L, 59.42, accuracy: 0.01)
                XCTAssertEqual(lab.a, 79.08, accuracy: 0.01)
                XCTAssertEqual(lab.b, 68.32, accuracy: 0.01)
            case .DonRGB4:
                let lab: Lab = LabCalculator.convert(RGB: rgb, workingSpace: space)
                
                XCTAssertEqual(lab.L, 59.74, accuracy: 0.01)
                XCTAssertEqual(lab.a, 111, accuracy: 0.01)
                XCTAssertEqual(lab.b, 95.99, accuracy: 0.01)
            case .ECIRGB:
                let lab: Lab = LabCalculator.convert(RGB: rgb, workingSpace: space)
                
                XCTAssertEqual(lab.L, 63.36, accuracy: 0.01)
                XCTAssertEqual(lab.a, 96.37, accuracy: 0.01)
                XCTAssertEqual(lab.b, 109.25, accuracy: 0.01)
            case .EktaSpacePS5:
                let lab: Lab = LabCalculator.convert(RGB: rgb, workingSpace: space)
                
                XCTAssertEqual(lab.L, 58.1, accuracy: 0.01)
                XCTAssertEqual(lab.a, 106.03, accuracy: 0.01)
                XCTAssertEqual(lab.b, 100.17, accuracy: 0.01)
            case .NTSCRGB:
                let lab: Lab = LabCalculator.convert(RGB: rgb, workingSpace: space)
                
                XCTAssertEqual(lab.L, 61.56, accuracy: 0.01)
                XCTAssertEqual(lab.a, 91.76, accuracy: 0.01)
                XCTAssertEqual(lab.b, 106.14, accuracy: 0.01)
            case .PALSECAMRGB:
                let lab: Lab = LabCalculator.convert(RGB: rgb, workingSpace: space)
                
                XCTAssertEqual(lab.L, 54.24, accuracy: 0.01)
                XCTAssertEqual(lab.a, 81.25, accuracy: 0.01)
                XCTAssertEqual(lab.b, 68.18, accuracy: 0.01)
            case .ProPhotoRGB:
                let lab: Lab = LabCalculator.convert(RGB: rgb, workingSpace: space)
                
                XCTAssertEqual(lab.L, 60.61, accuracy: 0.01)
                XCTAssertEqual(lab.a, 139.17, accuracy: 0.01)
                XCTAssertEqual(lab.b, 104.5, accuracy: 0.01)
            case .SMPTECRGB:
                let lab: Lab = LabCalculator.convert(RGB: rgb, workingSpace: space)
                
                XCTAssertEqual(lab.L, 53.21, accuracy: 0.01)
                XCTAssertEqual(lab.a, 74.35, accuracy: 0.01)
                XCTAssertEqual(lab.b, 67.69, accuracy: 0.01)
            case .sRGB:
                let lab: Lab = LabCalculator.convert(RGB: rgb, workingSpace: space)
                
                XCTAssertEqual(lab.L, 53.2408, accuracy: 0.001)
                XCTAssertEqual(lab.a, 80.0925, accuracy: 0.001)
                XCTAssertEqual(lab.b, 67.2032, accuracy: 0.001)
            case .WideGamutRGB:
                let lab: Lab = LabCalculator.convert(RGB: rgb, workingSpace: space)
                
                XCTAssertEqual(lab.L, 57.86, accuracy: 0.01)
                XCTAssertEqual(lab.a, 134.42, accuracy: 0.01)
                XCTAssertEqual(lab.b, 99.77, accuracy: 0.01)
            case .DisplayP3:
                let lab: Lab = LabCalculator.convert(RGB: rgb, workingSpace: space)
                
                XCTAssertEqual(lab.L, 54.97, accuracy: 0.01)
                XCTAssertEqual(lab.a, 94.09, accuracy: 0.01)
                XCTAssertEqual(lab.b, 94.78, accuracy: 0.01)
            case .Rec709:
                let lab: Lab = LabCalculator.convert(RGB: rgb, workingSpace: space)
                
                XCTAssertEqual(lab.L, 53.24, accuracy: 0.01)
                XCTAssertEqual(lab.a, 80.09, accuracy: 0.01)
                XCTAssertEqual(lab.b, 67.2, accuracy: 0.01)
            case .Rec2020:
                let lab: Lab = LabCalculator.convert(RGB: rgb, workingSpace: space)
                
                XCTAssertEqual(lab.L, 58.29, accuracy: 0.01)
                XCTAssertEqual(lab.a, 117.33, accuracy: 0.01)
                XCTAssertEqual(lab.b, 100.51, accuracy: 0.01)
            }
        }
    }
    
    func testRGBToLabGreen() {
        let green = UIColor.green
        let labGreen: Lab = LabCalculator.convert(RGB: RGB(red: green.cgColor.red, green: green.cgColor.green, blue: green.cgColor.blue), workingSpace: .sRGB)
        
        XCTAssertEqual(labGreen.L, 87.7347, accuracy: 0.001)
        XCTAssertEqual(labGreen.a, -86.1827, accuracy: 0.001)
        XCTAssertEqual(labGreen.b, 83.1793, accuracy: 0.001)
    }
    
    func testLabToRGBRed() {
        let red = Lab(L: 53.2408, a: 80.0925, b: 67.2032)
        let rgbRed: RGB = LabCalculator.convert(Lab: Lab(L: red.L, a: red.a, b: red.b), workingSpace: .sRGB)
        
        XCTAssertEqual(rgbRed.red255, 255)
        XCTAssertEqual(rgbRed.green255, 0)
        XCTAssertEqual(rgbRed.blue255, 0)
    }
    
    func testLabToRGBGreen() {
        let green = Lab(L: 87.7347, a: -86.1827, b: 83.1793)
        let rgbGreen: RGB = LabCalculator.convert(Lab: Lab(L: green.L, a: green.a, b: green.b), workingSpace: .sRGB)
        
        XCTAssertEqual(rgbGreen.red255, 0)
        XCTAssertEqual(rgbGreen.green255, 255)
        XCTAssertEqual(rgbGreen.blue255, 0)
    }

}
