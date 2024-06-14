//
//  UIImageColors.swift
//  dE CalculatorTests
//
//  Created by Denis Dmitriev on 05.06.2024.
//

import XCTest
@testable import Color_Streak

final class UIImageColors: XCTestCase {

    func testRGBGetColors() {
        let image = UIImage(resource: .rgb30X10)
        
        let colorsOnImage = image.getColors()
        XCTAssertEqual(colorsOnImage.count, 30 * 10)
        
        let alphaSet = Set(colorsOnImage.values.map({ $0.cgColor.alpha }))
        XCTAssertEqual(alphaSet.count, 1)
        XCTAssertEqual(alphaSet.first, 1)
        
        let differentColors = Set(colorsOnImage.values)
        XCTAssertEqual(differentColors.count, 3)
        
        let widthPoints = Set(colorsOnImage.keys.map({ $0.x }))
        XCTAssertEqual(widthPoints.count, 30)
        
        let heightPoints = Set(colorsOnImage.keys.map({ $0.y }))
        XCTAssertEqual(heightPoints.count, 10)
        
        let reds = colorsOnImage.filter { element in
            element.value.rgb == RGB(red: 1, green: 0, blue: 0)
        }
        XCTAssertEqual(reds.count, 10 * 10)
        let redRangeX = 0.0..<10.0
        XCTAssertTrue(redRangeX ~= reds.first!.key.x)
        XCTAssertEqual(reds.filter({ redRangeX ~= $0.key.x }).count, 10 * 10)
        
        let greens = colorsOnImage.filter { element in
            element.value.rgb == RGB(red: 0, green: 1, blue: 0)
        }
        XCTAssertEqual(greens.count, 10 * 10)
        let greenRangeX = 10.0..<20.0
        XCTAssertTrue(greenRangeX ~= greens.first!.key.x)
        XCTAssertEqual(greens.filter({ greenRangeX ~= $0.key.x }).count, 10 * 10)
        
        let blues = colorsOnImage.filter { element in
            element.value.rgb == RGB(red: 0, green: 0, blue: 1)
        }
        XCTAssertEqual(blues.count, 10 * 10)
        let blueRangeX = 20.0..<30.0
        XCTAssertTrue(blueRangeX ~= blues.first!.key.x)
        XCTAssertEqual(blues.filter({ blueRangeX ~= $0.key.x }).count, 10 * 10)
    }
    
    func testPaletteGetColors() {
        let image = UIImage(resource: .palette30X10)
        
        let colorsOnImage = image.getColors()
        XCTAssertEqual(colorsOnImage.count, 30 * 10)
        
        let alphaSet = Set(colorsOnImage.values.map({ $0.cgColor.alpha }))
        XCTAssertEqual(alphaSet.count, 1)
        XCTAssertEqual(alphaSet.first, 1)
        
        let differentColors = Set(colorsOnImage.values)
        XCTAssertEqual(differentColors.count, 3)
        
        let widthPoints = Set(colorsOnImage.keys.map({ $0.x }))
        XCTAssertEqual(widthPoints.count, 30)
        
        let heightPoints = Set(colorsOnImage.keys.map({ $0.y }))
        XCTAssertEqual(heightPoints.count, 10)
        
        let yellowRGB = RGB(red: 1, green: 223 / 255, blue: 0)
        let yellows = colorsOnImage.filter { element in
            element.value.rgb == yellowRGB
        }
        XCTAssertEqual(yellows.count, 10 * 10)
        let yellowRangeX = 0.0..<10.0
        XCTAssertTrue(yellowRangeX ~= yellows.first!.key.x)
        XCTAssertEqual(yellows.filter({ yellowRangeX ~= $0.key.x }).count, 10 * 10)
        
        let cyanRGB = RGB(red: 0, green: 1, blue: 240 / 255)
        let cyans = colorsOnImage.filter { element in
            element.value.rgb == cyanRGB
        }
        XCTAssertEqual(cyans.count, 10 * 10)
        let cyenRangeX = 10.0..<20.0
        XCTAssertTrue(cyenRangeX ~= cyans.first!.key.x)
        XCTAssertEqual(cyans.filter({ cyenRangeX ~= $0.key.x }).count, 10 * 10)
        
        let pinkRGB = RGB(red: 1, green: 0, blue: 173 / 255)
        let pinks = colorsOnImage.filter { element in
            element.value.rgb == pinkRGB
        }
        XCTAssertEqual(pinks.count, 10 * 10)
        let pinkRangeX = 20.0..<30.0
        XCTAssertTrue(pinkRangeX ~= pinks.first!.key.x)
        XCTAssertEqual(pinks.filter({ pinkRangeX ~= $0.key.x }).count, 10 * 10)
    }
    
    
    func testGetColorSRGB() {
        let image = UIImage(resource: .rgb30X10)
        
        let redPoint = CGPoint(x: 0, y: 0)
        let red = image.getColor(point: redPoint)
        XCTAssertEqual(red.rgb, RGB(red: 1, green: 0, blue: 0))
        XCTAssertEqual(red.cgColor.alpha, 1)
        
        let greenPoint = CGPoint(x: 10, y: 0)
        let green = image.getColor(point: greenPoint)
        XCTAssertEqual(green.rgb, RGB(red: 0, green: 1, blue: 0))
        XCTAssertEqual(green.cgColor.alpha, 1)
        
        let bluePoint = CGPoint(x: 20, y: 0)
        let blue = image.getColor(point: bluePoint)
        XCTAssertEqual(blue.rgb, RGB(red: 0, green: 0, blue: 1))
        XCTAssertEqual(blue.cgColor.alpha, 1)
    }
    
    func testGetColorDisplayP3() {
        let image = UIImage(resource: .rgb30X10DisplayP3)
        
        let redPoint = CGPoint(x: 0, y: 0)
        let red = image.getColor(point: redPoint)
        XCTAssertEqual(red.rgb, RGB(red: 1, green: 0, blue: 0))
        XCTAssertEqual(red.cgColor.alpha, 1)
        
        let greenPoint = CGPoint(x: 10, y: 0)
        let green = image.getColor(point: greenPoint)
        XCTAssertEqual(green.rgb, RGB(red: 0, green: 1, blue: 0))
        XCTAssertEqual(green.cgColor.alpha, 1)
        
        let bluePoint = CGPoint(x: 20, y: 0)
        let blue = image.getColor(point: bluePoint)
        XCTAssertEqual(blue.rgb, RGB(red: 0, green: 0, blue: 1))
        XCTAssertEqual(blue.cgColor.alpha, 1)
    }
    
    func testGetColorGray() {
        let image = UIImage(resource: .gray30X10)
        
        let grayPoint = CGPoint(x: 0, y: 0)
        let gray = image.getColor(point: grayPoint)
        XCTAssertEqual(gray.rgb, RGB(red: 129 / 255, green: 129 / 255, blue: 129 / 255))
        XCTAssertEqual(gray.cgColor.alpha, 1)
        
        let whitePoint = CGPoint(x: 10, y: 0)
        let white = image.getColor(point: whitePoint)
        XCTAssertEqual(white.rgb, RGB(red: 1, green: 1, blue: 1))
        XCTAssertEqual(white.cgColor.alpha, 1)
        
        let blackPoint = CGPoint(x: 20, y: 0)
        let black = image.getColor(point: blackPoint)
        XCTAssertEqual(black.rgb, RGB(red: 0, green: 0, blue: 0))
        XCTAssertEqual(black.cgColor.alpha, 1)
    }
}
