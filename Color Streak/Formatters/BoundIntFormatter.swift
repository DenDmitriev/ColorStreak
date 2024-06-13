//
//  BoundFormatter.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 17.05.2024.
//

import Foundation

/// https://stackoverflow.com/questions/72636810/swiftui-numeric-textfield-maximum-and-minimum-values
class BoundIntFormatter: Formatter {
    
    var max: Int = 0
    var min: Int = 0
    
    func clamp(with value: Int, min: Int, max: Int) -> Int{
        guard value <= max else {
            return max
        }
        
        guard value >= min else {
            return min
        }
        
        return value
    }
    
    func setMax(_ max: Int) {
        self.max = max
    }
    func setMin(_ min: Int) {
        self.min = min
    }
    
    override func string(for obj: Any?) -> String? {
        guard let number = obj as? Int else {
            return nil
        }
        return String(number)
        
    }
    
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        
        guard let number = Int(string) else {
            return false
        }
        
        obj?.pointee = clamp(with: number, min: self.min, max: self.max) as AnyObject
        
        return true
    }
    
}
