//
//  Coordinator.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 31.05.2024.
//

import SwiftUI

class Coordinator<Router: NavigationRouter, Failure: LocalizedError>: ObservableObject {
    
    @Published var path = NavigationPath()
    
    @Published var sheet: Router?
    @Published var cover: Router?
    
    @Published var hasError: Bool = false
    
    var error: Failure?
    
    func push(_ page: Router) {
        path.append(page)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func present(sheet: Router) {
        self.sheet = sheet
    }
    
    func dismissSheet() {
        sheet = nil
    }
    
    func present(cover: Router) {
        self.cover = cover
    }
    
    func dismissCover() {
        cover = nil
    }
    
    func presentAlert(error: Failure) {
        self.error = error
        hasError = true
    }
    
    func dismissErrorAlert() {
        DispatchQueue.main.async {
            self.error = nil
            self.hasError = false
        }
    }
    
    @ViewBuilder
    func build(_ route: Router) -> some View {
        route.view()
    }
}

