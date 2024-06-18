//
//  ImageState.swift
//  Color Streak
//
//  Created by Denis Dmitriev on 17.06.2024.
//

import SwiftUI

enum ImageState {
    case empty
    case loading(Progress)
    case success(UIImage)
    case failure(Error)
}
