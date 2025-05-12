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
        
        public init(
            minHue: Double = 0.2,
            maxHue: Double = 0.8,
            saturation: Double = 0.6,
            lightness: Double = 0.7,
            maxTiltX: Double = 0.2,
            maxTiltY: Double = 0.1,
            focalPointAdjustment: Double = 100.0
        ) {
            self.minHue = minHue
            self.maxHue = maxHue
            self.saturation = saturation
            self.lightness = lightness
            self.maxTiltX = maxTiltX
            self.maxTiltY = maxTiltY
            self.focalPointAdjustment = focalPointAdjustment
        }
    }
    
    // Configurable parameters
    @State private var configuration: Configuration
    
    // Motion tracking
    @State private var initialPitch: Double?
    @State private var initialRoll: Double?
    @State private var focalPoint: CGPoint = .zero
    
    // Motion manager
    private let motionManager = CMMotionManager()
    
    public init(configuration: Configuration = Configuration()) {
        self._configuration = State(initialValue: configuration)
    }
    
    public var body: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                
                // Create gradient based on current focal point
                for x in stride(from: 0, to: Int(size.width), by: 10) {
                    for y in stride(from: 0, to: Int(size.height), by: 10) {
                        let point = CGPoint(x: x, y: y)
                        let distance = hypot(point.x - focalPoint.x, point.y - focalPoint.y)
                        
                        // Calculate hue and color based on distance from focal point
                        let hue = mapRange(distance, 0, 500, configuration.minHue, configuration.maxHue)
                        let clampedHue = max(0, min(1, hue))
                        
                        let color = Color(
                            hue: clampedHue,
                            saturation: configuration.saturation,
                            brightness: configuration.lightness
                        )
                        
                        // Draw a small rectangle with the calculated color
                        let rect = CGRect(x: x, y: y, width: 10, height: 10)
                        context.fill(Path(rect), with: .color(color))
                    }
                }
            }
            .onAppear {
                startMotionTracking(in: geometry)
            }
            .onDisappear {
                motionManager.stopDeviceMotionUpdates()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    private func startMotionTracking(in geometry: GeometryProxy) {
        guard motionManager.isDeviceMotionAvailable else { return }
        
        // Set up motion updates
        motionManager.deviceMotionUpdateInterval = 0.1
        motionManager.startDeviceMotionUpdates(to: .main) { motion, error in
            guard let motion = motion else { return }
            
            // Capture initial orientation if not set
            if self.initialPitch == nil {
                self.initialPitch = motion.attitude.pitch
            }
            if self.initialRoll == nil {
                self.initialRoll = motion.attitude.roll
            }
            
            guard let initialPitch = self.initialPitch,
                  let initialRoll = self.initialRoll else { return }
            
            // Calculate changes in orientation
            let newPitch = motion.attitude.pitch
            let deltaPitch = newPitch - initialPitch
            
            let newRoll = motion.attitude.roll
            let deltaRoll = newRoll - initialRoll
            
            // Calculate focal point adjustments
            let yAdjustment = mapRange(deltaPitch,
                                       -configuration.maxTiltY,
                                       configuration.maxTiltY,
                                       -configuration.focalPointAdjustment,
                                       configuration.focalPointAdjustment)
            
            let xAdjustment = mapRange(deltaRoll,
                                       -configuration.maxTiltX,
                                       configuration.maxTiltX,
                                       -configuration.focalPointAdjustment,
                                       configuration.focalPointAdjustment)
            
            // Update focal point
            self.focalPoint = CGPoint(
                x: geometry.size.width / 2 + xAdjustment,
                y: geometry.size.height / 2 + yAdjustment
            )
        }
    }
}
