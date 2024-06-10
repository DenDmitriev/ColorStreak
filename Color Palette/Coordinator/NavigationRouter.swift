//
//  NavigationRouter.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 31.05.2024.
//

import SwiftUI

protocol NavigationRouter: Hashable, Identifiable {
    associatedtype V: View
    
    var title: String { get }
    
    @ViewBuilder
    func view() -> V
}
