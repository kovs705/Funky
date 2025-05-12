//
//  DotView.swift
//  Funky
//
//  Created by Eugene Kovs on 12.05.2025.
//  https://github.com/kovs705
//

import UIKit

class DotView: UIView {
    let gradient = CAGradientLayer()
    
    init() {
        super.init(frame: .zero)
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupGradient() {
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        layer.addSublayer(gradient)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
        gradient.cornerRadius = bounds.width / 2
    }
}
