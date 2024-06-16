//
//  CatalogView.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 30.05.2024.
//

import SwiftUI
import UniformTypeIdentifiers
import FirebaseAnalytics

struct CatalogView: View {
    @EnvironmentObject private var coordinator: Coordinator<CatalogRouter, CatalogError>
    @ObservedObject var shop: PaletteShop
    @State private var isSearching = false
    @State private var searchText: String = ""
    
    let columns: [GridItem] = [GridItem(.adaptive(minimum: 300, maximum: 500))]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(isSearching ? shop.palettes.filter({ $0.searchText.contains(searchText) }) : shop.palettes.sorted(by: { $1.dateModified < $0.dateModified })) { palette in
                    PaletteItemView(palette: palette)
                        .contextMenu {
                            contextMenuItems(palette: palette)
                        }
                }
                
                addNewButtonInList
                    .padding(.vertical, 24)
            }
            .padding()
        }
        .overlay(alignment: .bottomTrailing, content: {
            addNewButton
                .padding()
        })
        .overlay(alignment: .center) {
            switch shop.state {
            case .empty:
                if shop.palettes.isEmpty {
                    placeholderText(text: "No palettes")
                }
            case .loading:
                ProgressView()
                    .controlSize(.large)
            case .loaded:
                EmptyView()
            case .failure:
                placeholderText(text: "Error")
            }
        }
        .scrollDismissesKeyboard(.automatic)
        .searchable(text: $searchText, isPresented: $isSearching)
        .refreshable {
            await shop.fetchPalettes()
        }
        .task {
            if shop.palettes.isEmpty {
                await shop.fetchPalettes()
            }
        }
        .analyticsScreen(name: AnalyticsEvent.screen(view: "\(type(of: self))"))
    }
    
    private func placeholderText(text: String) -> some View {
        Text(text)
            .font(.title)
            .foregroundStyle(.quaternary)
    }
    
    private func contextMenuItems(palette: Palette) -> some View {
        Group {
            Button {
                coordinator.present(sheet: .detailPalette(palette))
            } label: {
                Label("Detail", systemImage: "rectangle.and.pencil.and.ellipsis")
            }
            
            Button {
                shareAction(palette: palette)
            } label: {
                Label("Share", systemImage: "square.and.arrow.up")
            }
            
            Button {
                duplicateAction(palette: palette)
            } label: {
                Label("Duplicate", systemImage: "plus.rectangle.on.rectangle")
            }
            
            Button(role: .destructive) {
                removeAction(palette: palette)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
    
    private var addNewButtonInList: some View {
        Button {
            addNewAction()
        } label: {
            Label("Add new pallet", systemImage: "plus")
        }
        .font(.system(size: 18, weight: .semibold))
    }
    
    private var addNewButton: some View {
        Button {
            addNewAction()
        } label: {
            Image(systemName: "plus.circle.fill")
        }
        .font(.largeTitle)
        .shadow(color: .black.opacity(0.12), radius: 10, x: -6)
    }
    
    private func addNewAction() {
        coordinator.present(sheet: .newPalette)
    }
    
    private func shareAction(palette: Palette) {
        coordinator.present(sheet: .share(palette))
        
        Analytics.logEvent(AnalyticsEventShare, parameters: [
            AnalyticsParameterItemName: palette.name,
            AnalyticsParameterContentType: Palette.self
        ])
    }
    
    private func removeAction(palette: Palette) {
        shop.remove(palette: palette)
    }
    
    private func duplicateAction(palette: Palette) {
        shop.duplicate(palette: palette)
    }
}

#Preview {
    NavigationStack {
        CatalogView(shop: .init(palettes: [.placeholder]))
            .environmentObject(Coordinator<CatalogRouter, CatalogError>())
    }
}
