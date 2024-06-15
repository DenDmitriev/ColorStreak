//
//  PalettAPI.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 04.06.2024.
//
// https://palett.es/api

import Foundation
import FirebaseCrashlytics

enum PalettAPIError: Error, LocalizedError {
    case invalidRequest
    case throwError(description: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidRequest:
            return "Invalid Request"
        case .throwError(let description):
            return description
        }
    }
}

struct PaletteAPI {
    
    enum Method {
        case random, keyColor(hex: String)
        
        var name: String {
            switch self {
            case .random:
                "Random Palette"
            case .keyColor(let hex):
                "Palette from \(hex)"
            }
        }
        
        var path: String {
            switch self {
            case .keyColor(let hex):
                "palette/from/\(hex)"
            case .random:
                "palette"
            }
        }
    }
    
    static var url: URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = "palett.es"
        urlComponents.path = "/API/v1"
        guard let url = urlComponents.url else {
            preconditionFailure("Invalid URL components: \(urlComponents)")
        }

        return url
    }
    
    static func getPalette(method: Method) async -> Result<Palette, PalettAPIError> {
        let url = url.appending(path: method.path)
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let hexColors = try JSONDecoder().decode([String].self, from: data)
            let palette = Palette(hexs: hexColors, name: method.name)
            
            return .success(palette)
        } catch {
            sendLogMessageCrashlytics(error: error, function: #function, url: url.absoluteString)
            return .failure(PalettAPIError.throwError(description: error.localizedDescription))
        }
    }
    
    static private func sendLogMessageCrashlytics(error: Error, function: String, url: String) {
        Crashlytics.crashlytics().log("Palette API: \(error.localizedDescription), \(function), url: \(url)")
    }
}
