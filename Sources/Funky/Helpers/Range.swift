//
//  Range.swift
//  Funky
//
//  Created by Eugene Kovs on 11.05.2025.
//  https://github.com/kovs705
//

import Foundation

/**
 Takes a value in range `(a, b)` and returns that value mapped to another range `(c, d)` using linear interpolation.
 
 For example, `0.5` mapped from range `(0, 1)` to range `(0, 100`) would produce `50`.
 
 Note that the return value is not clipped to the `out` range. For example, `mapRange(2, 0, 1, 0, 100)` would return `200`.
 */
public func mapRange<T: FloatingPoint>(value: T, inMin: T, inMax: T, outMin: T, outMax: T) -> T {
    ((value - inMin) * (outMax - outMin) / (inMax - inMin) + outMin)
}

/**
 The same function as `mapRange(value:inMin:inMax:outMin:outMax:)` but omitting the parameter names for terseness.
 */
public func mapRange<T: FloatingPoint>(_ value: T, _ inMin: T, _ inMax: T, _ outMin: T, _ outMax: T) -> T {
    mapRange(value: value, inMin: inMin, inMax: inMax, outMin: outMin, outMax: outMax)
}

/**
 Returns a value bounded by the provided range.
 - parameter lower: The minimum allowable value (inclusive).
 - parameter upper: The maximum allowable value (inclusive).
 */
public func clip<T: FloatingPoint>(value: T, lower: T, upper: T) -> T {
    min(upper, max(value, lower))
}

/**
 Returns a value bounded by the range `[0, 1]`.
 */
public func clipUnit<T: FloatingPoint>(value: T) -> T {
    clip(value: value, lower: 0, upper: 1)
}
