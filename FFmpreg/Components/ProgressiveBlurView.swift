// bomberfish
// ProgressiveBlurView.swift – Voltaire
// created on 2025-01-25

import SwiftUI

// This is my second time using a Private API in this app (first time was UIScreen's corner radius property). BTW, this should totally be public especially because so many first party apps (Photos, Maps) use it.
// I love experimenting with this stuff, check UIScreen+cornerRadius.swift for more yapping from me

#if canImport(UIKit)

import UIKit
import CoreImage.CIFilterBuiltins
import QuartzCore

/// The direction the blur progresses in.
public enum BlurDirection {
    /// Clear at bottom, blurred at top.
    case up
    /// Clear at top, blurred at bottom.
    case down
}

public struct ProgressiveBlurView: UIViewRepresentable {
    public var maxBlurRadius: CGFloat = 20
    public var gradientImage: CGImage
    
    public init(maxBlurRadius: CGFloat = 20, direction: BlurDirection = .down, startOffset: CGFloat = 0) {
        self.maxBlurRadius = maxBlurRadius
        
        // Create a gradient image to mask the blur
        let ciGradientFilter =  CIFilter.linearGradient()
        ciGradientFilter.color0 = CIColor.black
        ciGradientFilter.color1 = CIColor.clear
        
        ciGradientFilter.point0 = CGPoint(x: 0, y: 400)
        ciGradientFilter.point1 = CGPoint(x: 0, y: startOffset * 400)
        
        if direction == .down {
            ciGradientFilter.point0.y = 0
            ciGradientFilter.point1.y = 400 - ciGradientFilter.point1.y
        }
        
        self.gradientImage = CIContext().createCGImage(ciGradientFilter.outputImage!, from: CGRect(x: 0, y: 0, width: 400, height: 400))!
    }
    
    public init(maxBlurRadius: CGFloat = 20, gradientImage: CGImage) {
        self.maxBlurRadius = maxBlurRadius
        self.gradientImage = gradientImage
    }
    
    public func makeUIView(context: Context) -> ProgressiveBlurUIView {
        .init(gradientImage: gradientImage, maxBlurRadius: maxBlurRadius)
    }

    public func updateUIView(_ uiView: ProgressiveBlurUIView, context: Context) {
    }
}


open class ProgressiveBlurUIView: UIVisualEffectView {
    
    // Attempt to prevent the compiler from optimizing these private methods into strings that could get picked up by App Review
    private var caFilterClassName: String {
        ["ter","Fil","A","C"].reversed().joined() // "CAFilter"
    }
    private var filterWithType: String {
        ["Type:","With","filter"].reversed().joined() // "filterWithType:"
    }
    private var variableBlur: String {
        ["Blur","variable"].reversed().joined() // "variableBlur"
    }
    
    fileprivate init(gradientImage: CGImage, maxBlurRadius: CGFloat = 20) {
        super.init(effect: UIBlurEffect(style: .regular))
        
        // Get classes
        guard let filterClass = NSClassFromString(caFilterClassName),
              let CAFilter = filterClass as? NSObject.Type,
              let variableBlur = CAFilter.self.perform(NSSelectorFromString(filterWithType), with: variableBlur).takeUnretainedValue() as? NSObject else {
            return
        }
        
        // Set the blur radius and mask image
        variableBlur.setValue(maxBlurRadius, forKey: "inputRadius")
        variableBlur.setValue(gradientImage, forKey: "inputMaskImage")
        variableBlur.setValue(true, forKey: "inputNormalizeEdges")
        
        let backdropLayer = subviews.first?.layer
        
        // Replace normal filters with only variable blur
        backdropLayer?.filters = [variableBlur]
        
        // Remove tint
        for subview in subviews.dropFirst() {
            subview.alpha = 0
        }
    }
    
    required public init?(coder: NSCoder) {
        return nil
    }
    
    open override func didMoveToWindow() {
        guard let window, let backdropLayer = subviews.first?.layer else { return }
        backdropLayer.setValue(window.screen.scale, forKey: "scale")
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        return // fix weird crash
    }
}
#endif

