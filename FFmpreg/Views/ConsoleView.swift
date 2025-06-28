// bomberfish
// ConsoleView.swift – FFmpreg
// created on 2025-05-09

import SwiftUI

struct ConsoleView: View {
    var body: some View {
        NavigationStack {
            TerminalViewRepresentable()
                .background(Color(UIColor.black))
                .navigationTitle("Console")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
