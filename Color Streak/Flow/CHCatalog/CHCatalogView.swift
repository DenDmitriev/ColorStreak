//
//  CHCatalogView.swift
//  Color Palette
//
//  Created by Denis Dmitriev on 11.06.2024.
//

import SwiftUI

struct CHCatalogView: View {
    @EnvironmentObject private var coordinator: TabCoordinator<TabRouter>
    @EnvironmentObject private var catalogCoordinator: Coordinator<CHCatalogRouter, CatalogError>
    @EnvironmentObject var chShop: CHPaletteShop
    @EnvironmentObject var shop: PaletteShop
    @State private var palettes: [Palette] = []
    
    let columns: [GridItem] = [GridItem(.adaptive(minimum: 140, maximum: 500), spacing: 16)]
    
    var body: some View {
        ScrollView {
            HStack {
                Picker("Sort", selection: $chShop.sort) {
                    ForEach(ColorHunterSort.uiCases) { sort in
                        Text(sort.name)
                            .tag(sort)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding(.horizontal)
            
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(chShop.palettes) { palette in
                    CHPaletteItemView(palette: palette)
                        .contextMenu {
                            contextMenuItems(palette: palette)
                        }
                        .task {
                            await chShop.loadMore(currentItem: palette.id)
                        }
                }
            }
            .padding()
        }
        .scrollDismissesKeyboard(.automatic)
        .searchable(
            text: $chShop.searchText,
            tokens: $chShop.selectedTags, /*suggestedTokens: $chShop.suggestedTags*/
            isPresented: $chShop.searchIsActive,
            prompt: Text("Type to filter, or use @ for tags"),
            token: { tagItem(tag: $0) }
        )
        .overlay(alignment: .top, content: {
            if showSuggestedTags {
                SuggestedTagsSectionView(tags: $chShop.suggestedTags) { tag in
                    chShop.selectedTags.append(tag)
                    chShop.searchText.removeLast()
                }
                .transition(.asymmetric(insertion: .scale, removal: .opacity))
                .padding(12)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 28)
                .padding(.top, 8)
            }
        })
        .overlay(content: {
            switch chShop.state {
            case .empty:
                textPlaceholder("No palettes")
            case .loading:
                ProgressView()
                    .controlSize(.large)
                    .padding(24)
                    .tint(.secondary)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .loaded:
                Color.clear
            case .failure(let description):
                textPlaceholder(description)
            }
        })
        .ignoresSafeArea(edges: [.bottom])
        .navigationTitle("Library")
        .task {
            if chShop.palettes.isEmpty {
                await chShop.fetch()
            }
        }
        .onReceive(chShop.$sort.dropFirst()) { _ in
            chShop.selectedTags.removeAll()
            chShop.searchText.removeAll()
            Task {
                await chShop.reload()
            }
        }
        .onChange(of: chShop.debouncedSearchText) { _, debouncedSearchText in
            if debouncedSearchText.isEmpty {
                chShop.searchIsActive = false
                Task {
                    await chShop.reload()
                }
            } else {
                Task {
                    await chShop.reloadSearch()
                }
            }
        }
        .onChange(of: chShop.selectedTags) { _, newTags in
            if newTags.isEmpty {
                chShop.searchIsActive = false
                Task {
                    await chShop.reload()
                }
            } else {
                Task {
                    await chShop.reloadSearch()
                }
            }
        }
    }
    
    private var showSuggestedTags: Bool {
        chShop.searchText.starts(with: "@")
    }
    
    private func tagItem(tag: ColorHunterTag) -> some View {
        Label {
            Text(tag.name)
        } icon: {
            if let hex = tag.hex, let color = Color(hex: hex) {
                Circle()
                    .fill(color)
                    .frame(width: 16)
            } else {
                Image(systemName: "bookmark")
            }
        }
        .tint(.primary)
    }
    
    private func contextMenuItems(palette: Palette) -> some View {
        Group {
            Button {
                shop.add(palette: palette)
                coordinator.change(.catalog)
            } label: {
                Label("Add to catalog", systemImage: "plus")
            }
            
            Button {
                catalogCoordinator.present(sheet: .share(palette))
            } label: {
                Label("Share", systemImage: "square.and.arrow.up")
            }
        }
    }
    
    private func textPlaceholder(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 24, weight: .semibold))
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    NavigationStack {
        CHCatalogView()
            .environmentObject(CHPaletteShop())
            .environmentObject(PaletteShop())
            .environmentObject(TabCoordinator<TabRouter>(tab: .catalog))
            .environmentObject(Coordinator<CHCatalogRouter, CatalogError>())
    }
    .environmentObject(Coordinator<CatalogRouter, CatalogError>())
}
