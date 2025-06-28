// bomberfish
// UIApplication+firstWindow.swift – CO2AndU
// created on 2024-01-18

import UIKit

extension UIApplication {
    /// Get the first key window in an app
    var firstWindow: UIWindow? {
        if #available(iOS 15.0, *) {
//            genericLogger.debug("(\(#file):\(#line) — \(#function)) iOS 15.0+ detected, using new first window (where window is keywindow) method")
            // New method as of iOS 15
            return (connectedScenes.first as? UIWindowScene)?.windows.first(where: { $0.isKeyWindow })
        } else {
//            genericLogger.debug("(\(#file):\(#line) — \(#function)) iOS <15.0 detected, using older first window (where window is keywindow) method")
            // Old, deprecated method
            return windows.first(where: { $0.isKeyWindow })
        }
    }
    /// Get the first window in an app
    var absoluteFirstWindow: UIWindow? {
        if #available(iOS 15.0, *) {
//            genericLogger.debug("(\(#file):\(#line) — \(#function)) iOS 15.0+ detected, using new first window method")
            // New method as of iOS 15
            return (connectedScenes.first as? UIWindowScene)?.windows.first
        } else {
//            genericLogger.debug("(\(#file):\(#line) — \(#function)) iOS <15.0 detected, using older first window method")
            // Old, deprecated method
            return windows.first
        }
    }
}
