//
//  DotView.swift
//  Funky
//
//  Created by Eugene Kovs on 11.05.2025.
//  https://github.com/kovs705
//

import SwiftUI

struct DotView: View {
    var body: some View {
        Text("↑")
            .font(.system(size: 24))
            .minimumScaleFactor(0.1)
            .lineLimit(1)
            .frame(width: 40, height: 40) // You can customize the size
            .background(
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.gray.opacity(0.5), Color.gray]),
                            startPoint: .center,
                            endPoint: .bottomTrailing
                        )
                    )
            )
    }
}