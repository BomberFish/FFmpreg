 //
//  CGSize++.swift
//  AppCommander
//
//  Created by Hariz Shirazi on 2023-07-11.
//

import Foundation
import CoreGraphics

extension CGSize {
    /// Creates a square CGSize with equal width and height.
    init(size: CGFloat) {
        self.init(width: size, height: size)
    }
}
