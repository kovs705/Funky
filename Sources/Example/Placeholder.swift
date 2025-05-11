//
//  Placeholder.swift
//  Funky
//
//  Created by Eugene Kovs on 11.05.2025.
//  https://github.com/kovs705
//

import SwiftUI

/// Placeholder with some randomness
struct PlaceholderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(0..<15) { i in
                let width = CGFloat(Int.random(in: 40...300))
                let sectionBreak = ((i + 1) % 3 == 0) ? 40.0 : 0.0
                
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color(red: 0.82, green: 0.82, blue: 0.86))
                    .frame(width: width, height: 20)
                    .padding(.bottom, 10)
                
                if sectionBreak > 0 {
                    Spacer().frame(height: sectionBreak - 10)
                }
            }
        }
        .padding(.top, 50)
        .padding(.leading, 30)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
