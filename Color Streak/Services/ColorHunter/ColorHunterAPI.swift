//
//  ColorHunterAPI.swift
//  Color Palette
//
//  Created by Denis Dmitriev on 11.06.2024.
//

import Foundation
import FirebaseCrashlytics

struct ColorHunterAPI {
    enum ColorHunterError: Error, LocalizedError {
        case urlFailure
        case error(description: String)
    }
    
    /// Запрос на получение палитр с сайта [Color Hunter](https://colorhunt.co)
    /// ```curl
    /// curl --location 'https://colorhunt.co/php/feed.php' \
    /// --header 'Content-Type: application/x-www-form-urlencoded' \
    /// --data-urlencode 'step=0' \
    /// --data-urlencode 'sort='
    /// ```
    static func getPalettes(page: Int = .zero, sort: ColorHunterSort = .empty) async -> Result<[ColorHuntPalette], ColorHunterError> {
        guard let url = URL(string: "https://colorhunt.co/php/feed.php") else { return .failure(.urlFailure) }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
        var query = "step=\(page)"
        if sort != .empty {
            query.append("&sort=\(sort)")
        }
        query.append("&timeframe=30")
        print(query)
        let httpBody = query.data(using: .utf8)
        request.httpBody = httpBody
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let palettes = try JSONDecoder().decode([ColorHuntPalette].self, from: data)
            return.success(palettes)
        } catch {
            sendLogMessageCrashlytics(error: error, function: #function, url: url.absoluteString, query: query)
            return .failure(.error(description: error.localizedDescription))
        }
    }
    
    /// Запрос на получение палитр с сайта [Color Hunter](https://colorhunt.co)
    /// ```curl
    /// curl --location 'https://colorhunt.co/php/feed.php' \
    /// --header 'Content-Type: application/x-www-form-urlencoded' \
    /// --data-urlencode 'step=0' \
    /// --data-urlencode 'tags='
    /// ```
    static func searchPalettes(page: Int = .zero, tags: [ColorHunterTag], text: String) async -> Result<[ColorHuntPalette], ColorHunterError> {
        guard let url = URL(string: "https://colorhunt.co/php/feed.php") else { return .failure(.urlFailure) }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
        var query = "step=\(page)"
       
        var valueTags = ""
        if !tags.isEmpty {
            valueTags = tags.map({ $0.rawValue }).joined(separator: "-")
        }
        let tagText = text.lowercased().replacingOccurrences(of: " ", with: "-")
        if !tagText.isEmpty {
            if valueTags.last != "-", !valueTags.isEmpty { valueTags.append("-") }
            valueTags.append(tagText)
        }
        var formattedValueTags = valueTags
        formattedValueTags = valueTags.trimmingCharacters(in: .init(arrayLiteral: "-"))
        formattedValueTags = formattedValueTags.replacingOccurrences(of: "--", with: "-")
        query.append("&tags=\(formattedValueTags)")
        
        query.append("&timeframe=30")
        
        print(query)
        let httpBody = query.data(using: .utf8)
        request.httpBody = httpBody
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let palettes = try JSONDecoder().decode([ColorHuntPalette].self, from: data)
            return.success(palettes)
        } catch {
            sendLogMessageCrashlytics(error: error, function: #function, url: url.absoluteString, query: query)
            return .failure(.error(description: error.localizedDescription))
        }
    }
    
    static private func sendLogMessageCrashlytics(error: Error, function: String, url: String, query: String) {
        Crashlytics.crashlytics().log("Color Hunter API: \(error.localizedDescription), \(function), url: \(url), query: \(query)")
    }
}
