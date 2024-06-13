//
//  RGBTests.swift
//  dE CalculatorTests
//
//  Created by Denis Dmitriev on 05.06.2024.
//

import XCTest
@testable import Color_Palette

final class RGBTests: XCTestCase {
    
    func testIsEqual() {
        let red = RGB(red: 1, green: 0, blue: 0)
        let redAccuracy = RGB(red: 254 / 255, green: 1 / 255, blue: 0)
        
        XCTAssertNotEqual(red, redAccuracy)
        
        let isEqualAccuracy = red.isEqual(with: redAccuracy, accuracy: 1)
        XCTAssertTrue(isEqualAccuracy)
        
        let isNotEqualAccuracy = red.isEqual(with: redAccuracy, accuracy: 0)
        XCTAssertFalse(isNotEqualAccuracy)
    }

}
