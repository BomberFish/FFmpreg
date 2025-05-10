//
//  CommonFunctions.swift
//  Picasso
//
//  Created by Hariz Shirazi on 2023-08-07.
//

import Foundation
import UIKit

/// Exit app gracefully
@MainActor public func exitApp() {
//    ExploitKit.shared.CleanUp()
    UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil) // Exit to the home screen
    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
        exit(0) // Terminate after a bit
    }
}

public func URLtoTS(_ url: URL?) -> URL {
    return URL(string: "apple-magnifier://install?url=" + (url?.absoluteString ?? "")) ?? .init(string: "apple-magnifier://ballstoreos")!
}

/// Share item with a share sheet.
@MainActor public func shareURL(_ url: URL) {
    let vc = UIActivityViewController(activityItems: [url as Any], applicationActivities: nil)
    Haptic.shared.notify(.success)
    vc.isModalInPresentation = true
    UIApplication.shared.dismissAlert(animated: true)
    UIApplication.shared.firstWindow?.rootViewController?.present(vc, animated: true)
    UIApplication.shared.dismissAlert(animated: true)
    vc.isModalInPresentation = true
}

//func convertToCCharPointer(_ swiftString: String) -> UnsafeMutablePointer<Int8>? {
//    // Convert Swift String to a null-terminated C string (UTF-8 encoded)
//    if let cString = swiftString.cString(using: .utf8) {
//        // Create a mutable pointer to the C string
//        let cCharPointer = UnsafeMutablePointer<Int8>(mutating: cString)
//        return cCharPointer
//    }
//    return nil
//}
