//
//  FunkyViewRepresentable.swift
//  Funky
//
//  Created by Eugene Kovs on 12.05.2025.
//  https://github.com/kovs705
//

import SwiftUI
import UIKit
import CoreMotion

// UIViewRepresentable to bridge between SwiftUI and UIKit
struct FunkyBackgroundViewRepresentable: UIViewRepresentable {
    var configuration: FunkyBackgroundView.Configuration
    
    // Motion tracking
    private let motionManager = CMMotionManager()
    
    func makeUIView(context: Context) -> FunkyBackgroundUIView {
        let view = FunkyBackgroundUIView()
        view.minHue = configuration.minHue
        view.maxHue = configuration.maxHue
        view.saturation = configuration.saturation
        view.lightness = configuration.lightness
        view.dotSize = configuration.dotSize
        view.dotSpacing = configuration.dotSpacing
        
        return view
    }
    
    func updateUIView(_ uiView: FunkyBackgroundUIView, context: Context) {
        if !context.coordinator.isMotionStarted {
            context.coordinator.startMotionTracking(for: uiView, with: configuration)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(motionManager: motionManager)
    }
    
    // Coordinator to handle motion updates
    class Coordinator: NSObject {
        let motionManager: CMMotionManager
        var initialPitch: Double?
        var initialRoll: Double?
        var isMotionStarted = false
        
        init(motionManager: CMMotionManager) {
            self.motionManager = motionManager
        }
        
        @MainActor func startMotionTracking(for view: FunkyBackgroundUIView, with configuration: FunkyBackgroundView.Configuration) {
            guard motionManager.isDeviceMotionAvailable, !isMotionStarted else { return }
            
            isMotionStarted = true
            
            // Set up motion updates with a reasonable interval for performance
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
                guard let self = self, let motion = motion else { return }
                
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
                let newFocalPoint = CGPoint(
                    x: view.bounds.width / 2 + xAdjustment,
                    y: view.bounds.height / 2 + yAdjustment
                )
                
                view.updateColors(withFocalPoint: newFocalPoint)
            }
        }
        
        deinit {
            motionManager.stopDeviceMotionUpdates()
        }
    }
}
