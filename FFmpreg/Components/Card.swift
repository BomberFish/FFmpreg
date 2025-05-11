// bomberfish
// ArgumentCard.swift – FFmpreg
// created on 2025-05-09

import SwiftUI

struct ArgumentCard: View {
    @Binding var arg: any FFmpegArgument
    public var onDelete: (() -> Void)?
    var body: some View {
        VStack {
            HStack {
                Image(systemName: arg.icon)
                Text(arg.name)
                    .font(.headline)
                Spacer()
            }
            HStack {
                Text(arg.help)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                Spacer()
            }
            TextEditor(text: $arg.value)
                .frame(minHeight: 100)
                .modifier(FancyInputViewModifier())
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
        }
        .padding()
        .background(.ultraThinMaterial)
        .overlay(alignment: .topTrailing) {
            Button(action: {
                Haptic.shared.play(.soft, intensity: 0.2)
                onDelete?()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 22))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.foreground)
            }
            .padding()
        }
        .cornerRadius(18)
    }
}

struct FileImportCard: View {
    @Binding var path: URL?
    @State private var showPicker: Bool = false
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "folder")
                Text("Select File")
                    .font(.headline)
                Spacer()
            }
            Button(action: {
                showPicker = true
            }, label: {
                Label(path?.lastPathComponent ?? "Select File", systemImage: "folder")
                    .frame(maxWidth: . infinity)
            })
            .frame(maxWidth: .infinity)
            .buttonStyle(.bordered)
            .tint(.accentColor)
            .controlSize(.large)
            .cornerRadius(14)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(18)
        .sheet(isPresented: $showPicker) {
            DocumentImporter(filePath: $path, utTypes: [.audio, .video, .movie])
                .presentationCornerRadius(18)
                .presentationDragIndicator(.visible)
        }
    }
}

struct FileExportCard: View {
    @Binding var name: String
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "folder")
                Text("Export File")
                    .font(.headline)
                Spacer()
            }
            TextField("Output Filename", text: $name)
                .frame(idealHeight: 32, maxHeight: 32)
                .modifier(FancyInputViewModifier())
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(18)
    }
}
