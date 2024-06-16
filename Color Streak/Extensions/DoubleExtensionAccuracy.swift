//
//  DoubleExtensionAccuracy.swift
//  Color Streak
//
//  Created by Denis Dmitriev on 16.06.2024.
//

import Foundation

extension Double {
    func isEqual(value: Self, accuracy: Self) -> Bool {
        (value - accuracy)...(value + accuracy) ~= self
    }
}

extension CGFloat {
    func isEqual(value: Self, accuracy: Self) -> Bool {
        (value - accuracy)...(value + accuracy) ~= self
    }
}
