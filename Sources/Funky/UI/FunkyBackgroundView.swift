//
//  FunkyBackgroundView.swift
//  Funky
//
//  Created by Eugene Kovs on 11.05.2025.
//  https://github.com/kovs705
//

import SwiftUI
import UIKit
import CoreMotion

// SwiftUI wrapper for our UIKit implementation
public struct FunkyBackgroundView: View {
    // Configuration options for customizing the background
    public struct Configuration {
        public var minHue: Double
        public var maxHue: Double
        public var saturation: Double
        public var lightness: Double
        public var maxTiltX: Double
        public var maxTiltY: Double
        public var focalPointAdjustment: Double
        public var dotSize: CGFloat
        public var dotSpacing: CGFloat
        
        public init(
            minHue: Double = 0.2,
            maxHue: Double = 0.8,
            saturation: Double = 0.6,
            lightness: Double = 0.7,
            maxTiltX: Double = 0.2,
            maxTiltY: Double = 0.1,
            focalPointAdjustment: Double = 100.0,
            dotSize: CGFloat = 10.0,
            dotSpacing: CGFloat = 15.0
        ) {
            self.minHue = minHue
            self.maxHue = maxHue
            self.saturation = saturation
            self.lightness = lightness
            self.maxTiltX = maxTiltX
            self.maxTiltY = maxTiltY
            self.focalPointAdjustment = focalPointAdjustment
            self.dotSize = dotSize
            self.dotSpacing = dotSpacing
        }
    }
    
    // Configurable parameters
    private var configuration: Configuration
    
    public init(configuration: Configuration = Configuration()) {
        self.configuration = configuration
    }
    
    public var body: some View {
        FunkyBackgroundViewRepresentable(configuration: configuration)
            .edgesIgnoringSafeArea(.all)
    }
}

// Extension to create UIColor from hue, saturation, lightness
//extension UIColor {
//    convenience init(hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat) {
//        // Convert HSL to HSB (which is what UIKit uses)
//        let brightness = lightness + saturation * min(lightness, 1 - lightness)
//        let newSaturation = brightness == 0 ? 0 : 2 * (1 - lightness / brightness)
//        
//        self.init(hue: hue, saturation: newSaturation, brightness: brightness, alpha: alpha)
//    }
//}
