// bomberfish
// fancyViewInputModifier.swift – Picasso
// created on 2023-12-08

import SwiftUI

public struct FancyInputViewModifier: ViewModifier {
    public func body(content: Content) -> some View {
        Group {
            content
                .frame(minHeight: 32)
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                .textEditorStyle(.plain)
                .textFieldStyle(.plain)
                
        }
            .frame(minHeight: 32)
        .cornerRadius(14)
    }
}

fileprivate struct Glass: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    public func body(content: Content) -> some View {
        if #available(iOS 19.0, *) {
            content
                .glassEffect(.regular.interactive(), in: .capsule)
        } else {
            content
                .overlay(
                    RoundedRectangle(cornerRadius: .infinity)
                        .stroke(colorScheme == .dark ? .white.opacity(0.035): Color.accentColor.opacity(0.4), lineWidth: 2)
                        .frame(minHeight: 48, idealHeight: 48)
                )
                .background(
                    .ultraThinMaterial
                )

                .cornerRadius(.infinity)
        }
    }
}
