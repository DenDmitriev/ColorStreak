//
//  ColorCoordinate.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 25.05.2024.
//

import Foundation

enum ColorCoordinate: String, CaseIterable, Identifiable {
    /// 0...1 to 0...100%
    case percent
    /// 0...1 to 0...360
    case degree
    /// 0...1 to 0...1
    case decimal
    /// 0...1 to 0...255
    case bits
    /// 0...100 to 0...100
    case normal
    /// -100....100
    case balance
    
    var id: String {
        self.rawValue
    }
    
    var range: ClosedRange<Double> {
        switch self {
        case .percent, .decimal:
            0...1
        case .degree:
            0...359
        case .bits:
            0...255
        case .normal:
            0...100
        case .balance:
            -100...100
        }
    }
    
    var accuracy: Double {
        let range = range.upperBound - range.lowerBound
        switch self {
        case .percent, .decimal:
            return 0.9 * 0.01 / range
        case .degree:
            return 0.9 * 1 / range
        case .bits:
            return 0.9 * 1 / range
        case .normal:
            return 0.9 * 1 / range
        case .balance:
            return 0.9 * 1 / range
        }
    }
    
    var increment: Double {
        switch self {
        case .percent, .decimal:
            0.01
        case .degree, .bits, .normal, .balance:
            1
        }
    }
    
    private func formatted(value: Double) -> String {
        switch self {
        case .percent:
            let formatter = NumberFormatter()
            formatter.numberStyle = .percent
            return formatter.string(from: value as NSNumber) ?? "0"
        case .degree:
            let measurement = Measurement<UnitAngle>(value: value, unit: .degrees)
            let formatter = MeasurementFormatter()
            formatter.unitOptions = .providedUnit
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.numberFormatter.maximumFractionDigits = 0
            return formatter.string(from: measurement)
        case .decimal:
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter.string(from: value as NSNumber) ?? "0"
        case .bits, .normal, .balance:
            let formatter = NumberFormatter()
            formatter.numberStyle = .none
            return formatter.string(from: value as NSNumber) ?? "0"
        }
    }
    
    func text(value: Double) -> String {
        switch self {
        case .degree:
            var proxy = value * 360
            if value == 360 {
                proxy = 0
            }
            return formatted(value: proxy)
        case .percent, .decimal:
            return formatted(value: value)
        case .bits:
            return formatted(value: value * 255)
        case .normal:
            return formatted(value: value * 100)
        case .balance:
            let balancedValue = (value - 0.5) * 2
            return formatted(value: balancedValue * 100)
        }
    }
}
