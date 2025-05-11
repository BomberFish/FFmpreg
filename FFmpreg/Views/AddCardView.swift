// bomberfish
// AddCardView.swift – FFmpreg
// created on 2025-05-09

import SwiftUI

struct AddCardView: View {
    @Binding var args: [any FFmpegArgument]
    public var types: [any FFmpegArgument]
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            List(types, id: \.id) { type in
                Button(action: {
                    withAnimation {
                        Haptic.shared.play(.soft)
                        args.append(type)
                    }
                    dismiss()
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: type.icon)
                            .font(.system(size: 18))
                            .frame(width: 18)
                        VStack(alignment: .leading) {
                            Text(type.name)
                                .font(.headline)
                                .foregroundColor(.primary)
                            Text(type.help)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Add Option")
            .navigationBarTitleDisplayMode(.inline)
            .scrollContentBackground(.hidden)
            .listRowBackground(Color.white.opacity(0.05))
        }
    }
}
