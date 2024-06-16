//
//  Copyable.swift
//  Color Streak
//
//  Created by Denis Dmitriev on 16.06.2024.
//

import Foundation

protocol Copyable {
    init(copy: Self)
}

extension Copyable {
    func copy() -> Self {
        return Self.init(copy: self)
    }
}
