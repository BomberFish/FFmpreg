// bomberfish
// ContentView.swift – FFmpreg
// created on 2025-05-08

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State var arguments: String = ""
    @State var path: URL?
    @State var outFileName: String = ""
    @State var showPicker: Bool = false
    @State var showConsole: Bool = false
    @State var currentType: FFmpegArgumentType = .outfile
    @State var options: [any FFmpegArgument] = []
    @State var infileOptions: [any FFmpegArgument] = []
    @State var outfileOptions: [any FFmpegArgument] = []
    @State var infile: URL = URL(fileURLWithPath: "")
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach($options, id: \.id) { $arg in
                    ArgumentCard(arg: $arg, onDelete: {
                        if let index = options.firstIndex(where: { $0.id == arg.id }) {
                            withAnimation {
                                _ = options.remove(at: index)
                            }
                        }
                    })
                }
                ForEach($infileOptions, id: \.id) { $arg in
                    ArgumentCard(arg: $arg, onDelete: {
                        if let index = infileOptions.firstIndex(where: { $0.id == arg.id }) {
                            withAnimation {
                                _ = infileOptions.remove(at: index)
                            }
                        }
                    })
                }
//                Button(action: {
//                    currentType = .infile
//                    showPicker = true
//                }, label: {
//                    Label("Input Option", systemImage: "plus.circle.fill")
//                        .frame(maxWidth: . infinity)
//                })
                .frame(maxWidth: .infinity)
                .buttonStyle(.bordered)
                .controlSize(.large)
                .tint(.accentColor)
                FileImportCard(path: $path)
                ForEach($outfileOptions, id: \.id) { $arg in
                    ArgumentCard(arg: $arg, onDelete: {
                        if let index = outfileOptions.firstIndex(where: { $0.id == arg.id }) {
                            withAnimation {
                                _ = outfileOptions.remove(at: index)
                            }
                        }
                    })
                }
                Button(action: {
                    currentType = .outfile
                    showPicker = true
                }, label: {
                    Label("Output Option", systemImage: "plus.circle.fill")
                        .frame(maxWidth: . infinity)
                })
                .frame(maxWidth: .infinity)
                .buttonStyle(.bordered)
                .controlSize(.large)
                .tint(.accentColor)
                FileExportCard(name: $outFileName)
            }
            .padding()
        }
        .onChange(of: path) {
            outFileName = path?.lastPathComponent ?? ""
        }
        .overlay(alignment: .bottom) {
            Button(action: {
                showConsole = true
                DispatchQueue.global(qos: .background).async {
                    do {
                        let ffmpeg = FFmpegRunner(options: options, infileOptions: infileOptions, infile: path!, outfileOptions: outfileOptions, outfileName: outFileName)
                        try ffmpeg.run()
                    } catch {
                        print("Error running FFmpeg: \(error)")
                    }
                }
            }, label: {
                Label("Run", systemImage: "play.fill")
                    .frame(maxWidth: . infinity)
            })
            .frame(maxWidth: .infinity)
            .disabled(path == nil)
            .controlSize(.large)
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .sheet(isPresented: $showPicker) {
            AddCardView(args: $outfileOptions, selectedType: $currentType)
        }
        .sheet(isPresented: $showConsole) {
            ConsoleView()
        }
    }
}


