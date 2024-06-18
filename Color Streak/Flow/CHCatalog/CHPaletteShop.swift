//
//  CHPaletteShop.swift
//  Color Palette
//
//  Created by Denis Dmitriev on 11.06.2024.
//

import Foundation
import Combine

class CHPaletteShop: ObservableObject {
    typealias API = ColorHunterAPI
    @Published var palettes: [Palette] = .empty
    @Published var state: State = .empty
    @Published var selectedTags: [ColorHunterTag] = []
    @Published var suggestedTags: [ColorHunterTag] = ColorHunterTag.allCases
    @Published var sort: ColorHunterSort = .new
    @Published var error: API.ColorHunterError?
    @Published var searchText: String = ""
    @Published var debouncedSearchText: String = ""
    @Published var searchIsActive = false
    
    private var totalPages = 99
    private let perPage = 40
    private var page = 0
    
    private var bag = Set<AnyCancellable>()
    
    init() {
        searchBind()
    }
    
    func searchBind(dueTime: TimeInterval = 1) {
        $searchText
            .removeDuplicates()
            .debounce(for: .seconds(dueTime), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                guard value != "@" else { return }
                self?.debouncedSearchText = value
            })
            .store(in: &bag)
    }
    
    private func state(_ state: State) {
        guard self.state != state else { return }
        DispatchQueue.main.async {
            self.state = state
        }
    }
    
    func reload() async {
        state(.loading)
        self.page = 0
        let result = await API.getPalettes(page: page, sort: sort)
        switch result {
        case .success(let success):
            DispatchQueue.main.async {
                self.palettes = success.map({ $0.palette })
                self.state(.loaded)
            }
        case .failure(let failure):
            DispatchQueue.main.async {
                self.error = failure
                self.state(.failure(description: failure.localizedDescription))
            }
        }
    }
    
    func fetch() async {
        let result = await API.getPalettes(page: page, sort: sort)
        switch result {
        case .success(let success):
            DispatchQueue.main.async {
                self.palettes.append(contentsOf: success.map({ $0.palette }))
                self.state(.loaded)
            }
        case .failure(let failure):
            DispatchQueue.main.async {
                self.error = failure
                self.state(.failure(description: failure.localizedDescription))
            }
        }
    }
    
    func reloadSearch() async {
        state(.loading)
        self.page = 0
        let result = await API.searchPalettes(page: page, tags: selectedTags, text: debouncedSearchText)
        switch result {
        case .success(let success):
            DispatchQueue.main.async {
                self.palettes = success.map({ $0.palette })
                self.state(.loaded)
            }
        case .failure(let failure):
            DispatchQueue.main.async {
                self.error = failure
                self.state(.failure(description: failure.localizedDescription))
            }
        }
    }
    
    func fetchSearch() async {
        let result = await API.searchPalettes(page: page, tags: selectedTags, text: debouncedSearchText)
        switch result {
        case .success(let success):
            DispatchQueue.main.async {
                self.palettes.append(contentsOf: success.map({ $0.palette }))
                self.state(.loaded)
            }
        case .failure(let failure):
            DispatchQueue.main.async {
                self.error = failure
                self.state(.failure(description: failure.localizedDescription))
            }
        }
    }
    
    func loadMore(currentItem itemID: Palette.ID) async {
        if itemID == palettes.last?.id, page <= totalPages {
            page += 1
            searchIsActive ? await fetchSearch() : await fetch()
        }
    }
}

extension CHPaletteShop {
    enum State: Equatable {
        case empty, loading, loaded, failure(description: String)
    }
}
