//
//  LibraryStackView.swift
//  Color Streak
//
//  Created by Denis Dmitriev on 17.06.2024.
//

import SwiftUI

struct LibraryStackView: View {
    @EnvironmentObject private var tabCoordinator: TabCoordinator<TabRouter>
    @EnvironmentObject private var coordinator: Coordinator<HomeRouter, HomeError>
    @EnvironmentObject var chShop: CHPaletteShop
    
    var body: some View {
        VStack(spacing: 8) {
            SectionHeader(title: String(localized: "Library"), budge: .new, action: toLibrary)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(Array(zip(chShop.palettes.indices, chShop.palettes)), id: \.0) { index, palette in
                        let isFirst = index == 0
                        let isLast = index == chShop.palettes.count - 1
                        PaletteHomeItemView(palette: palette, kind: .library)
                            .padding(.leading, isFirst ? 16 : 0)
                            .padding(.trailing, isLast ? 16 : 0)
                            .task {
                                await chShop.loadMore(currentItem: palette.id)
                            }
                    }
                }
            }
        }
        .task {
            await chShop.reload()
        }
    }
    
    private func toLibrary() {
        tabCoordinator.change(.library)
    }
}

#Preview {
    LibraryStackView()
        .environmentObject(TabCoordinator<TabRouter>(tab: .main))
        .environmentObject(Coordinator<HomeRouter, HomeError>())
        .environmentObject(CHPaletteShop())
}

