// bomberfish
// ConsoleView.swift – FFmpreg
// created on 2025-05-09

import SwiftUI

struct ConsoleView: View {
    @ObservedObject var pipe = OutPipe.shared
    var body: some View {
//        TerminalViewRepresentable(text: $pipe.output)
        TextEditor(text: $pipe.output)
    }
}

//#Preview {
//    ConsoleView()
//}
