//
//  AnalyticsEvent.swift
//  Color Streak
//
//  Created by Denis Dmitriev on 15.06.2024.
//

import Foundation

enum AnalyticsEvent: String {
    /// Создание новой палитры
    case createPalette = "create_palette"
    /// Импорт палитры из библиотеки
    case importPalette = "import_palette"
    /// Создание палитры из изображения
    case createImagePalette = "create_image_palette"
    /// Проверка контраста
    case contrastChecker = "contrast_checker"
    
    static func screen(view named: String) -> String {
        named
    }
    
    var key: String {
        self.rawValue
    }
    
    private func toSnakeCase() -> String? {
        let pattern = "([a-z0-9])([A-Z])"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: self.rawValue.count)
        return regex?.stringByReplacingMatches(in: self.rawValue, options: [], range: range, withTemplate: "$1_$2").lowercased()
    }
}
