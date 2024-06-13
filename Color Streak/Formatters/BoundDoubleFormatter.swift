//
//  BoundDoubleFormatter.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 17.05.2024.
//

import Foundation

class BoundDoubleFormatter: Formatter {
    
    var max: Double = 0
    var min: Double = 0
    
    func clamp(with value: Double, min: Double, max: Double) -> Double{
        guard value <= max else {
            return max
        }
        
        guard value >= min else {
            return min
        }
        
        return value
    }
    
    func setMax(_ max: Double) {
        self.max = max
    }
    func setMin(_ min: Double) {
        self.min = min
    }
    
    override func string(for obj: Any?) -> String? {
        guard let number = obj as? Double else {
            return nil
        }
        return String(number)
        
    }
    
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        
        guard let number = Double(string) else {
            return false
        }
        
        obj?.pointee = clamp(with: number, min: self.min, max: self.max) as AnyObject
        
        return true
    }
    
}
