//
//  ContentView.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 17.05.2024.
// 

import SwiftUI

struct ContentView: View {
    @StateObject var catalogCoordinator: Coordinator<CatalogRouter, CatalogError> = .init()
    @StateObject var libraryCoordinator: Coordinator<CHCatalogRouter, CatalogError> = .init()
    @StateObject var coordinator: TabCoordinator<TabRouter> = .init(tab: .catalog)
    
    
    @State var colors: [Color] = [.red, .green, .blue]
    let initial: [Color] = [.red, .green, .blue]
    @State var controller: PalettePickView.ColorController = .wheel
    
    @State var selectedIIndex: Int = .zero
    
    var body: some View {
//        VStack {
//            ColorHueSaturationWheel(colorSpace: .constant(.displayP3), colors: $colors, selected: Binding(get: { selectedIIndex }, set: { selectedIIndex = $0 ?? 0 }), brightness: .constant(1), controller: $controller)
//            
//            HStack {
//                ForEach(colors.indices, id: \.self) { index in
//                    RoundedRectangle(cornerRadius: 24)
//                        .stroke(.primary, lineWidth: selectedIIndex == index ? 5 : 0)
//                        .fill(colors[index])
//                        .onTapGesture {
//                            controller = .selection
//                            selectedIIndex = index
//                        }
//                }
//            }
//            .frame(height: 100)
//            
//            HSBColorPicker(color: $colors[selectedIIndex], initial: initial[selectedIIndex], colorSpace: .constant(.displayP3), controller: $controller)
//        }
//        .padding()
        
        TabCoordinatorView()
            .environmentObject(coordinator)
            .environmentObject(libraryCoordinator)
            .environmentObject(catalogCoordinator)
    }
}

#Preview {
    ContentView()
        .environmentObject(PaletteShop())
        .environmentObject(CHPaletteShop())
}
