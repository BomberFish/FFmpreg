// bomberfish
// UIUserInterfaceIdiom+isLargeScreenFormat.swift – CO2AndU
// created on 2024-01-15

import UIKit

// MARK: - UIDevice
extension UIDevice {
    /// Whether the current device is a large screen (iPad, Mac (When optimize interface for Mac is on), Apple TV, or Apple Vision Pro)
    var isLargeScreenFormat: Bool {
        let idiom = self.userInterfaceIdiom
        if #available(iOS 17.0, *) {
            // Vision Pro idiom is only present on iOS 17.0+
            return (idiom == .pad || idiom == .mac || idiom == .tv || idiom == .vision)
        } else {
            return (idiom == .pad || idiom == .mac || idiom == .tv)
        }
    }
    /// Whether the current device is a spatial computing device.
    var isXR: Bool {
        let idiom = self.userInterfaceIdiom
        if #available(iOS 17.0, *) {
            // Vision Pro idiom is only present on iOS 17.0+
            return idiom == .vision
        } else {
            return false
        }
    }
    
    /// Whether the current device is a desktop
    var isDesktop: Bool {
        let idiom = self.userInterfaceIdiom
        if #available(iOS 17.0, *) {
            // Vision Pro idiom is only present on iOS 17.0+
            return ( idiom == .mac || idiom == .vision )
        } else {
            return idiom == .mac
        }
    }
    
    /// Whether the current device can use the sidebar UI
    var isSidebarEligible: Bool {
        if self.userInterfaceIdiom == .pad {
            return UIApplication.shared.firstWindow?.bounds.width ?? 1 > UIApplication.shared.firstWindow?.bounds.height ?? 2
        } else {
            return isDesktop
        }
    }
    
    /// Returns `true` if the device has a notch
    var hasNotch: Bool {
        guard #available(iOS 11.0, *), let window = UIApplication.shared.firstWindow else { return false }
        if UIDevice.current.orientation.isPortrait {
            return window.safeAreaInsets.top >= 44
        } else {
            return window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0
        }
    }
}

// MARK: - UIUserInterfaceIdiom
extension UIUserInterfaceIdiom {
    /// Formatted name of the current idiom.
    var prettyName: String {
        switch self {
        case .phone:
            return "iPhone"
        case .pad:
            return "iPad"
        case .vision:
            return "Apple Vision Pro"
        case .mac:
            return "Mac Catalyst"
        case .tv:
            return "Apple TV"
        case .carPlay:
            return "CarPlay"
        case .unspecified:
            return "Unspecified"
        default:
            return "Unknown Device \(self.rawValue)"
        }
    }
}

