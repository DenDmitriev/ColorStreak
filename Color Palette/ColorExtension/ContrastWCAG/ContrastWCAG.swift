//
//  ContrastWCAG.swift
//  Color Palette
//
//  Created by Denis Dmitriev on 08.06.2024.
//

import SwiftUI

struct ContrastWCAG {
    
    public enum Compliance {
        case AA
        case AAA
        
        public enum Element {
            case normalText, largeText, uiComponents
        }
        
        /// WCAG 2.0
        var aspectNormalText: Double {
            switch self {
            case .AA:
                4.5
            case .AAA:
                7.0
            }
        }
        
        /// WCAG 2.0
        var aspectLargeText: Double {
            switch self {
            case .AA:
                3.0
            case .AAA:
                4.5
            }
        }
        
        /// WCAG 2.1
        var aspectUIComponents: Double {
            switch self {
            case .AA:
                3.0
            case .AAA:
                3.0
            }
        }
        
        public func result(aspect: Double, for element: Element) -> Bool {
            switch element {
            case .normalText:
                aspect >= self.aspectNormalText
            case .largeText:
                aspect >= self.aspectLargeText
            case .uiComponents:
                aspect >= self.aspectUIComponents
            }
        }
    }
    
    /// Color for foreground.
    public var foreground: CGColor
    
    /// Color for background.
    public var background: CGColor
    
    /// Contrast Ratio
    /// Color contrast refers to the difference in brightness between background and foreground colors.
    /// Contrast ratios can range from 1 to 21 (commonly written 1:1 to 21:1).
    public var contrast: Double {
        ContrastWCAGCalculator.contrastRatio(foreground, background, invertible: true)
    }
    
    /// Contrast Checker
    ///
    /// - Returns: WCAG AA and AAA Results
    public func checker(compliance: Compliance, for element: Compliance.Element) -> Bool {
        compliance.result(aspect: contrast, for: element)
    }
}

extension ContrastWCAG {
    init(foreground: Color, background: Color) {
        self.foreground = UIColor(foreground).cgColor
        self.background = UIColor(background).cgColor
    }
    
    init(foreground: UIColor, background: UIColor) {
        self.foreground = foreground.cgColor
        self.background = background.cgColor
    }
}
