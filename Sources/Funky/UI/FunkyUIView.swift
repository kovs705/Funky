//
//  FunkyUIView.swift
//  Funky
//
//  Created by Eugene Kovs on 12.05.2025.
//  https://github.com/kovs705
//

import UIKit

// UIKit view that will handle the actual dots implementation
class FunkyBackgroundUIView: UIView {
    // Configuration options
    var minHue: Double = 0.2
    var maxHue: Double = 0.8
    var saturation: Double = 0.6
    var lightness: Double = 0.7
    var dotSize: CGFloat = 10.0
    var dotSpacing: CGFloat = 15.0
    
    // Performance optimizations
    private var dotViews: [DotView] = []
    private var colorCache: [ColorCacheKey: UIColor] = [:]
    
    // Focal point for gradient calculation
    var focalPoint: CGPoint = .zero
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Sets up the dots in a grid pattern
    func setupDots() {
        clearDots()
        
        let width = bounds.width
        let height = bounds.height
        
        // Calculate how many dots we need based on spacing
        let rows = Int(height / dotSpacing) + 1
        let columns = Int(width / dotSpacing) + 1
        
        // Create dots in grid pattern
        for row in 0..<rows {
            for col in 0..<columns {
                let x = CGFloat(col) * dotSpacing
                let y = CGFloat(row) * dotSpacing
                
                // Create and position dot
                let dot = DotView()
                dot.bounds.size = CGSize(width: dotSize, height: dotSize)
                dot.center = CGPoint(x: x, y: y)
                
                // Only add dots that are inside our view bounds
                if dot.frame.intersects(bounds) {
                    addSubview(dot)
                    dotViews.append(dot)
                }
            }
        }
        
        // Set initial colors based on center focal point
        if focalPoint == .zero {
            focalPoint = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        }
        updateColors(withFocalPoint: focalPoint)
    }
    
    private func clearDots() {
        for dot in dotViews {
            dot.removeFromSuperview()
        }
        dotViews.removeAll()
    }
    
    // Updates colors similar to CardView implementation
    func updateColors(withFocalPoint point: CGPoint) {
        // Disable implicit animations for better performance
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        // The range for minimum to maximum hue based on distance
        let radiusForMinimumHue = 0.0
        let radiusForMaximumHue = 500.0
        
        var currentSaturation = saturation
        let currentLightness = lightness
        
        // Start desaturating dots that are very far from focal point
        let distanceToBeginDesaturation = 550.0
        let distanceToEndDesaturation = 800.0
        
        for dot in dotViews {
            // Calculate the distance from the dot to the focal point
            let xDist = abs(dot.center.x - point.x)
            let yDist = abs(dot.center.y - point.y)
            let distanceFromFocalPoint = hypot(xDist, yDist)
            
            // Calculate gradient colors for the dot
            var startHue = mapRange(distanceFromFocalPoint - 20, radiusForMinimumHue, radiusForMaximumHue, minHue, maxHue)
            var endHue = mapRange(distanceFromFocalPoint, radiusForMinimumHue, radiusForMaximumHue, minHue, maxHue)
            
            // Desaturate dots that are far away
            if distanceFromFocalPoint >= distanceToBeginDesaturation {
                currentSaturation = mapRange(distanceFromFocalPoint, distanceToBeginDesaturation, distanceToEndDesaturation, saturation, 0)
            } else {
                currentSaturation = saturation
            }
            
            // Constrain values within [0, 1]
            startHue = clipUnit(value: startHue)
            endHue = clipUnit(value: endHue)
            currentSaturation = clipUnit(value: currentSaturation)
            
            // Round values for caching
            let startHueRounded = Double(round(100 * startHue) / 100)
            let endHueRounded = Double(round(100 * endHue) / 100)
            let saturationRounded = Double(round(100 * currentSaturation) / 100)
            
            // Cache colors for performance
            let startColorKey = ColorCacheKey(hue: startHueRounded, saturation: saturationRounded, lightness: currentLightness)
            let endColorKey = ColorCacheKey(hue: endHueRounded, saturation: saturationRounded, lightness: currentLightness)
            
            var startColor = colorCache[startColorKey]
            var endColor = colorCache[endColorKey]
            
            if startColor == nil {
                startColor = UIColor(hue: startHueRounded, saturation: saturationRounded, lightness: currentLightness, alpha: 1)
                colorCache[startColorKey] = startColor
            }
            
            if endColor == nil {
                endColor = UIColor(hue: endHueRounded, saturation: saturationRounded, lightness: currentLightness, alpha: 1)
                colorCache[endColorKey] = endColor
            }
            
            // Update the dot's gradient colors
            dot.gradient.colors = [startColor!.cgColor, endColor!.cgColor]
        }
        
        CATransaction.commit()
    }
    
    // Handle layout changes
    override func layoutSubviews() {
        super.layoutSubviews()
        if dotViews.isEmpty {
            setupDots()
        }
    }
    
    // Helper function to constrain values to [0, 1]
    func clipUnit(value: Double) -> Double {
        return max(0, min(1, value))
    }
}
