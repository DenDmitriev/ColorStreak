//
//  PaletteShop.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 30.05.2024.
//

import Foundation
import Combine
import CoreData
import FirebaseCrashlytics

class PaletteShop: ObservableObject {
    @Published var palettes: [Palette] = []
    @Published var state: State = .empty
    
    private var coreDataManager: CoreDataManager = .shared
    private var cancellable = Set<AnyCancellable>()
    
    init(palettes: [Palette] = []) {
        self.palettes = palettes
        bindPalettesUpdate()
    }
    
    subscript(id: Palette.ID) -> Palette {
        get {
            let index = index(id: id)
            assert(index != nil, "Non-existent identifier \(Palette.self)")
            return palettes[index!]
        }
        
        set(newPalette) {
            guard let index = palettes.firstIndex(where: { $0.id == id })
            else { return }
            palettes[index] = newPalette
        }
    }
    
    func fetchPalettes() async {
        state(is: .loading)
        do {
            let palettes = try await coreDataManager.fetchPalettes()
            DispatchQueue.main.async {
                self.palettes = palettes
                self.state(is: .loaded)
            }
        } catch {
            print(error.localizedDescription)
            state(is: .failure)
            sendLogMessageCrashlytics(error: error, function: #function)
        }
    }
    
    private func state(is state: State) {
        DispatchQueue.main.async {
            self.state = state
        }
    }
    
    private func index(id: Palette.ID) -> Int? {
        return palettes.firstIndex(where: { $0.id == id })
    }
    
    @discardableResult
    func add(palette: Palette) -> Bool {
        guard !palette.colors.isEmpty,
              !palettes.contains(palette)
        else { return false }
        
        if palette.name.isEmpty, let generatedName = palette.generateName() {
            palette.name = generatedName
        }
        
        if palette.tags.isEmpty {
            palette.autoTags()
        }
        
        palette.isNew = true
        
        palettes.append(palette)
        Task(priority: .background) {
            await coreDataManager.addPalette(palette: palette)
        }
        return true
    }
    
    @discardableResult
    func remove(palette: Palette) -> Bool {
        guard palettes.contains(palette) else { return false }
        palettes.removeAll(where: { palette.id == $0.id })
        Task(priority: .background) {
            try await coreDataManager.deletePalette(palette: palette)
        }
        return true
    }
    
    @discardableResult
    func removeAll() -> Bool {
        guard !palettes.isEmpty else { return false }
        palettes.removeAll()
        Task(priority: .background) {
            try await coreDataManager.deleteAllPalettes()
        }
        return true
    }
    
    @discardableResult
    func duplicate(palette: Palette) -> Bool {
        guard let duplicate = palette.copy() as? Palette else { return false }
        return add(palette: duplicate)
    }
    
    private func bindPalettesUpdate() {
        $palettes
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellable)
    }
    
    private func sendLogMessageCrashlytics(error: Error, function: String) {
        Crashlytics.crashlytics().record(error: error, userInfo: ["Palette Shop" : function])
    }
}

extension PaletteShop {
    static var placeholder: PaletteShop = {
        let shop = PaletteShop()
        let palette = Palette(colors: [.red, .orange, .yellow, .green, .cyan, .blue, .purple], name: "Palette")
        shop.palettes.append(palette)
        return shop
    }()
}

extension PaletteShop {
    enum State {
        case empty, loading, loaded, failure
    }
}
