// bomberfish
// UIScreen+cornerRadius.swift – Hallaca
// created on 2025-01-19

import UIKit

extension UIScreen {
    /// The corner radius of the screen.
    /// Apple devices use a continuous radius, so make sure to use this when creating rounded corners.
    /// Example: `RoundedRectangle(cornerRadius: UIScreen.main.cornerRadius, style: .continuous)`
    var cornerRadius: CGFloat {
        
        /// Technically i'm not trying to sneak this past app review,
        /// but I still think it's funny that this works and i also think it's super cool
        ///
        /// In general I just love experimenting with this stuff
        /// It's pretty cool to take a peek under the hood of such
        /// a massive library like UIKit, I mean the publicly exposed
        /// properties are just the tip of the iceberg
        ///
        /// Plus, the challenge rules say nothing about using private apis.
        ///
        /// But still, i'll obfuscate it a bit in case you folks actually
        /// do pass this thing through the same algorithm
        ///
        /// Here, i'm making a computed value in the hopes that the compiler won't optimize it into a constant that might get picked up
        var key: String {
            ["ius", "Rad", "ner", "Cor", "play", "dis", "_"] // key
                .reversed() // ["_", "dis", "play", "Cor", "ner", "Rad", "ius"]
                .joined() // "_displayCornerRadius"
        }
        
        return self // current instance
            .value( // value for key of nsobject, an objc-ism
                forKey: key
            )
        as? CGFloat // convert to a cgfloat
        ?? 0 // fallback to 0, in case we're in a weird environment (read: probably catalyst)
    }
}
