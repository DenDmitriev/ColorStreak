//
//  ColorPickerPanel.swift
//  Color Palette
//
//  Created by Denis Dmitriev on 08.06.2024.
//

import SwiftUI

struct ColorPickerPanel: UIViewControllerRepresentable {
    @Binding var color: Color
    @Binding var isShow: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, isShow: $isShow)
    }
    
    func makeUIViewController(context: Context) -> UIColorPickerViewController {
        let picker = UIColorPickerViewController()
        picker.delegate = context.coordinator
        picker.modalPresentationStyle = .formSheet
        return picker
    }
    
    func updateUIViewController(_ picker: UIColorPickerViewController, context: Context) {
        picker.selectedColor = UIColor(color)
    }
    
    class Coordinator: NSObject, UIColorPickerViewControllerDelegate {
        var parent: ColorPickerPanel
        @Binding var isShow: Bool
        
        init(_ pageViewController: ColorPickerPanel, isShow: Binding<Bool>) {
            self.parent = pageViewController
            self._isShow = isShow
        }
        
        func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
            parent.color = Color(uiColor: viewController.selectedColor)
        }
        
        func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
            isShow = false
        }
    }
}
