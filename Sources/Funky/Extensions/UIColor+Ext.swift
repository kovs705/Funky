//
//  UIColor+Ext.swift
//  Funky
//
//  Created by Eugene Kovs on 11.05.2025.
//  https://github.com/kovs705
//

import UIKit

/**
 Source: https://stackoverflow.com/questions/62632213/swift-use-hsl-color-space-instead-of-standard-hsb-hsv
 */
extension UIColor {
    convenience init(hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat) {
        precondition(0...1 ~= hue &&
                     0...1 ~= saturation &&
                     0...1 ~= lightness &&
                     0...1 ~= alpha, "input range is out of range 0...1")
        
        //From HSL TO HSB ---------
        var newSaturation: CGFloat = 0.0
        
        let brightness = lightness + saturation * min(lightness, 1-lightness)
        
        if brightness == 0 { newSaturation = 0.0 }
        else {
            newSaturation = 2 * (1 - lightness / brightness)
        }
        //---------
        
        self.init(hue: hue, saturation: newSaturation, brightness: brightness, alpha: alpha)
    }
}
