//
//  ColorCacheKey.swift
//  Funky
//
//  Created by Eugene Kovs on 11.05.2025.
//  https://github.com/kovs705
//

import Foundation

struct ColorCacheKey: Hashable {
    let hue: CGFloat
    let saturation: CGFloat
    let lightness: CGFloat
}
