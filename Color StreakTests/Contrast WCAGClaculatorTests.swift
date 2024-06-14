//
//  ContrastWCAGCalculatorTests.swift
//  Color PaletteTests
//
//  Created by Denis Dmitriev on 08.06.2024.
//

import XCTest
@testable import Color_Streak

final class ContrastWCAGCalculatorTests: XCTestCase {

    func testContrastBW() {
        let white = CGColor.white
        let black = CGColor.black
        
        let contrastRatio = ContrastWCAGCalculator.contrastRatio(white, black)
        
        XCTAssertEqual(contrastRatio, 21)
    }
    
    func testContrastRB() {
        let red = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
        let green = CGColor(red: 0, green: 1, blue: 0, alpha: 1)
        
        let contrastRatio = ContrastWCAGCalculator.contrastRatio(red, green)
        
        XCTAssertEqual(contrastRatio, 2.91)
    }
    
    func testContrastBG() {
        let blue = CGColor(red: 0, green: 0, blue: 1, alpha: 1)
        let green = CGColor(red: 0, green: 1, blue: 0, alpha: 1)
        
        let contrastRatio = ContrastWCAGCalculator.contrastRatio(blue, green)
        
        XCTAssertEqual(contrastRatio, 6.26)
    }
    
    func testContrastGray() {
        let gray = CGColor(red: 214 / 255, green: 214 / 255, blue: 214 / 255, alpha: 1)
        let color = CGColor(red: 0, green: 140 / 255, blue: 180 / 255, alpha: 1)
        
        let contrastRatio = ContrastWCAGCalculator.contrastRatio(gray, color)
        
        XCTAssertEqual(contrastRatio, 2.67)
    }
    
    func testComplianceWB() {
        let white = CGColor.white
        let black = CGColor.black
        
        let contrast = ContrastWCAG(foreground: white, background: black)
        
        XCTAssertTrue(contrast.checker(compliance: .AA, for: .normalText))
        XCTAssertTrue(contrast.checker(compliance: .AAA, for: .normalText))
        
        XCTAssertTrue(contrast.checker(compliance: .AA, for: .largeText))
        XCTAssertTrue(contrast.checker(compliance: .AAA, for: .largeText))
        
        XCTAssertTrue(contrast.checker(compliance: .AA, for: .uiComponents))
        XCTAssertTrue(contrast.checker(compliance: .AAA, for: .uiComponents))
    }
    
    func testComplianceBW() {
        let white = CGColor.white
        let black = CGColor.black
        
        let contrastWCAG = ContrastWCAG(foreground: black, background: white)
        
        XCTAssertEqual(contrastWCAG.contrast, 21)
        
        XCTAssertTrue(contrastWCAG.checker(compliance: .AA, for: .normalText))
        XCTAssertTrue(contrastWCAG.checker(compliance: .AAA, for: .normalText))
        
        XCTAssertTrue(contrastWCAG.checker(compliance: .AA, for: .largeText))
        XCTAssertTrue(contrastWCAG.checker(compliance: .AAA, for: .largeText))
        
        XCTAssertTrue(contrastWCAG.checker(compliance: .AA, for: .uiComponents))
        XCTAssertTrue(contrastWCAG.checker(compliance: .AAA, for: .uiComponents))
    }
    
    func testComplianceWW() {
        let white = CGColor.white
        
        let contrastWCAG = ContrastWCAG(foreground: white, background: white)
        
        XCTAssertEqual(contrastWCAG.contrast, 1)
        
        XCTAssertFalse(contrastWCAG.checker(compliance: .AA, for: .normalText))
        XCTAssertFalse(contrastWCAG.checker(compliance: .AAA, for: .normalText))
        
        XCTAssertFalse(contrastWCAG.checker(compliance: .AA, for: .largeText))
        XCTAssertFalse(contrastWCAG.checker(compliance: .AAA, for: .largeText))
        
        XCTAssertFalse(contrastWCAG.checker(compliance: .AA, for: .uiComponents))
        XCTAssertFalse(contrastWCAG.checker(compliance: .AAA, for: .uiComponents))
    }
    
    func testComplianceSomeColors() {
        let foreground = CGColor(red: 1, green: 228 / 255, blue: 168 / 255, alpha: 1)
        let background = CGColor(red: 170 / 255, green: 121 / 255, blue: 66 / 255, alpha: 1)
        
        let contrastWCAG = ContrastWCAG(foreground: foreground, background: background)
        
        XCTAssertEqual(contrastWCAG.contrast, 3.06)
        
        XCTAssertFalse(contrastWCAG.checker(compliance: .AA, for: .normalText))
        XCTAssertFalse(contrastWCAG.checker(compliance: .AAA, for: .normalText))
        
        XCTAssertTrue(contrastWCAG.checker(compliance: .AA, for: .largeText))
        XCTAssertFalse(contrastWCAG.checker(compliance: .AAA, for: .largeText))
        
        XCTAssertTrue(contrastWCAG.checker(compliance: .AA, for: .uiComponents))
        XCTAssertTrue(contrastWCAG.checker(compliance: .AAA, for: .uiComponents))
    }

}
