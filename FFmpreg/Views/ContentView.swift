// bomberfish
// ContentView.swift – FFmpreg
// created on 2025-05-08

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State var path: URL?
    @State var outFileName: String = ""
    @State var infile: URL = URL(fileURLWithPath: "")
    
    @State var options: [any FFmpegArgument] = []
    @State var infileOptions: [any FFmpegArgument] = []
    @State var outfileOptions: [any FFmpegArgument] = []
    
    @State var showOptions: Bool = false
    @State var showInOptions: Bool = false
    @State var showOutOptions: Bool = false
    @State var showConsole: Bool = false
    
    @State var running = false
    
    var body: some View {
        GeometryReader {geo in
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
                    Button(action: {
                        showOptions = true
                    }, label: {
                        Label("FFmpeg Option", systemImage: "plus.circle.fill")
                            .frame(maxWidth: . infinity)
                    })
                    .modifier(ButtonModifier())
                    Divider()
                    ForEach($infileOptions, id: \.id) { $arg in
                        ArgumentCard(arg: $arg, onDelete: {
                            if let index = infileOptions.firstIndex(where: { $0.id == arg.id }) {
                                withAnimation {
                                    _ = infileOptions.remove(at: index)
                                }
                            }
                        })
                    }
                    Button(action: {
                        showInOptions = true
                    }, label: {
                        Label("Input Option", systemImage: "plus.circle.fill")
                            .frame(maxWidth: . infinity)
                    })
                    .modifier(ButtonModifier())
                    Divider()
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
                        showOutOptions = true
                    }, label: {
                        Label("Output Option", systemImage: "plus.circle.fill")
                            .frame(maxWidth: . infinity)
                    })
                    .modifier(ButtonModifier())
                    Divider()
                    FileExportCard(name: $outFileName)
                }
                .padding()
                .padding(.bottom, 64)
            }
            .background(
                RadialGradient(colors: [.init(hex: "16063C"), .init(hex: "060011")], center: .top, startRadius: 0, endRadius: geo.size.width)
                    .ignoresSafeArea(.all)
            )
        }
        .scrollDismissesKeyboard(.interactively)
        .onChange(of: path) {
            outFileName = path?.lastPathComponent ?? ""
        }
        .overlay(alignment: .top) {
            ZStack(alignment: .top) {
                if UIDevice.current.hasNotch {
                    ProgressiveBlurView(maxBlurRadius: 2, direction: .up)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .ignoresSafeArea(.all, edges: .top)
                }
            }
        }
        .overlay(alignment: .bottom) {
            Button(action: {
                showConsole = true
                running = true
                DispatchQueue.global(qos: .background).async {
                    do {
                        let ffmpeg = FFmpegRunner(options: options, infileOptions: infileOptions, infile: path!, outfileOptions: outfileOptions, outfileName: outFileName)
                        try ffmpeg.run()
                    } catch {
                        print("Error running FFmpeg: \(error)")
                    }
                    running = false
                }
            }, label: {
                Label("Run", systemImage: "play.fill")
                    .frame(maxWidth: .infinity)
            })
            .background(.ultraThinMaterial)
            .frame(maxWidth: .infinity)
            .disabled(path == nil)
            .controlSize(.large)
            .buttonStyle(.borderedProminent)
            .cornerRadius(18)
            .padding()
        }
        .sheet(isPresented: $showConsole) {
            ConsoleView()
                .presentationDragIndicator(running ? .hidden : .visible)
                .interactiveDismissDisabled(running)
                .presentationCornerRadius(18)
        }
        .sheet(isPresented: $showOptions) {
            AddCardView(args: $options, types: [CustomFFmpegArgument()])
                .modifier(AddSheetModifier())
        }
        .sheet(isPresented: $showInOptions) {
            AddCardView(args: $infileOptions, types: [CustomFFmpegArgument()])
                .modifier(AddSheetModifier())
        }
        .sheet(isPresented: $showOutOptions) {
            AddCardView(args: $outfileOptions, types: [VideoCodec(), VideoBitrate(), VideoFilter(), AudioCodec(), AudioBitrate(), AudioFilter(), CustomFFmpegArgument()])
                .modifier(AddSheetModifier())
        }
    }
}

fileprivate struct ButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .buttonStyle(.bordered)
            .controlSize(.large)
            .tint(.accentColor)
            .cornerRadius(18)
    }
}

fileprivate struct AddSheetModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
            .presentationBackground(.thinMaterial)
            .presentationCornerRadius(18)
    }
}
