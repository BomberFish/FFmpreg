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
                .textEditorStyle(.automatic)
                .frame(height: 100)
                .cornerRadius(12)
                .font(.body)
        }
        .padding()
        .background(.ultraThinMaterial)
        .overlay(alignment: .topTrailing) {
            Button(action: {
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
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(18)
        .sheet(isPresented: $showPicker) {
            DocumentImporter(filePath: $path, utTypes: [.audio, .video, .movie])
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
                .textFieldStyle(.roundedBorder)
                .padding()
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(18)
    }
}
