// bomberfish
// fancyViewInputModifier.swift – Picasso
// created on 2023-12-08

import SwiftUI

public struct FancyInputViewModifier: ViewModifier {

    @Environment(\.colorScheme) private var colorScheme

    public func body(content: Content) -> some View {
        Group {
            content
                .frame(minHeight: 32)
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                .textEditorStyle(.plain)
                .textFieldStyle(.plain)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(colorScheme == .dark ? .white.opacity(0.035): Color.accentColor.opacity(0.4), lineWidth: 2)
                        .frame(minHeight: 48, idealHeight: 48)
                )
                .background(
//                    Color.accentColor.opacity(colorScheme == .dark ?0.075:0.0)
//                    Color(UIColor.secondarySystemBackground)
                    .ultraThinMaterial
                )

                .cornerRadius(14)
        }
            .frame(minHeight: 32)
//        .background(colorScheme == .dark ? Material.ultraThinMaterial:Material.thickMaterial)
        .cornerRadius(14)
    }
}
