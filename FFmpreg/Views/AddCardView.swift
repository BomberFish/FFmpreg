// bomberfish
// AddCardView.swift – FFmpreg
// created on 2025-05-09

import SwiftUI

// TODO: Better way of getting types
let types: [any FFmpegArgument] = [VideoCodec(), VideoBitrate(), AudioCodec(), AudioBitrate(), VideoFilter(), AudioFilter(), CustomFFmpegArgument()]

struct AddCardView: View {
    @Binding var args: [any FFmpegArgument]
    @Binding var selectedType: FFmpegArgumentType
    @State var filteredTypes: [any FFmpegArgument] = types
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            List($filteredTypes, id: \.id) { type in
                Button(action: {
                    withAnimation {
                        args.append(type.wrappedValue)
                    }
                    dismiss()
                }) {
                    HStack(spacing: 10) {
                        Image(systemName: type.wrappedValue.icon)
                            .font(.system(size: 18))
                            .frame(width: 18)
                        VStack(alignment: .leading) {
                            Text(type.wrappedValue.name)
                                .font(.headline)
                                .foregroundColor(.primary)
                            Text(type.wrappedValue.help)
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
        }
        .onChange(of: selectedType) {new in
            filteredTypes = types.filter { $0.type == new || $0.type == .custom }
//            print(filteredTypes)
        }
    }
}
