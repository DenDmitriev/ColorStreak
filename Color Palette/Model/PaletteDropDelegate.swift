//
//  PaletteDropDelegate.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 03.06.2024.
//

import SwiftUI

struct PaletteDropDelegate: DropDelegate {
    let item: Palette
    @Binding var items: [Palette]
    @Binding var draggedItem : Palette?
    
    func performDrop(info: DropInfo) -> Bool {
        return true
    }
    
    func dropEntered(info: DropInfo) {
        guard let draggedItem,
              draggedItem != item,
              let from = items.firstIndex(of: draggedItem),
              let to = items.firstIndex(of: item)
        else { return }

        withAnimation(.default) {
            self.items.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? to + 1 : to)
        }
    }
}
