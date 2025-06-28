// bomberfish
// TerminalViewRepresentable.swift – FFmpreg
// created on 2025-05-08

import SwiftUI
import SwiftTerm

struct TerminalViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> TerminalView {
        let terminalView = TerminalView()
        terminalView.nativeForegroundColor = UIColor.white
        terminalView.nativeBackgroundColor = UIColor.black
        terminalView.setFonts(
            normal: .monospacedSystemFont(ofSize: 14, weight: .regular),
            bold: .monospacedSystemFont(ofSize: 14, weight: .bold),
            italic: .monospacedSystemFont(ofSize: 14, weight: .thin),
            boldItalic: .monospacedSystemFont(ofSize: 14, weight: .bold)
        )
        terminalView.terminalDelegate = OutputConsoleDelegate()
        
        consolePipe.fileHandleForReading.readabilityHandler = { handle in
            let data = handle.availableData
            let bytes = [UInt8](data)
            DispatchQueue.main.async {
//                print(String(data: data, encoding: .utf8) ?? "[*] <Non-text data of size\(data.count)>")
                terminalView.feed(byteArray: .init(bytes))
//                terminalView.feed(text: "\n")
            }
        }
        
        return terminalView
    }
    
    func updateUIView(_ uiView: TerminalView, context: Context) {
        
    }
}

public class OutputConsoleDelegate: TerminalViewDelegate {
    public func sizeChanged(source: SwiftTerm.TerminalView, newCols: Int, newRows: Int) {
        return
    }
    
    public func setTerminalTitle(source: SwiftTerm.TerminalView, title: String) {
        return
    }
    
    public func hostCurrentDirectoryUpdate(source: SwiftTerm.TerminalView, directory: String?) {
        return
    }
    
    public func send(source: SwiftTerm.TerminalView, data: ArraySlice<UInt8>) {
        consolePipe.fileHandleForWriting.write(Data(data))
    }
    
    public func scrolled(source: SwiftTerm.TerminalView, position: Double) {
        return
    }
    
    public func requestOpenLink(source: SwiftTerm.TerminalView, link: String, params: [String : String]) {
        guard let url = URL(string: link) else { return }
        UIApplication.shared.open(url)
    }
    
    public func clipboardCopy(source: SwiftTerm.TerminalView, content: Data) {
        if let str = String(data: content, encoding: .utf8) {
            UIPasteboard.general.string = str
        }
    }
    
    public func rangeChanged(source: SwiftTerm.TerminalView, startY: Int, endY: Int) {
        return
    }

    public func bell (source: TerminalView) {
        Task {
            await MainActor.run {
                Haptic.shared.play(.rigid)
            }
        }
    }
}
