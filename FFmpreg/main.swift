// bomberfish
// main.swift – FFmpreg
// created on 2025-05-08

import Foundation
import SwiftUICore
import OSLog

var pipe = Pipe()

class OutPipe: ObservableObject {
    static var shared = OutPipe()
    @Published var output: String = ""
}

//setvbuf(stdout, nil, _IONBF, 0)
//setvbuf(stderr, nil, _IONBF, 0)

dup2(pipe.fileHandleForWriting.fileDescriptor,
     STDOUT_FILENO)
dup2(pipe.fileHandleForWriting.fileDescriptor,
     STDERR_FILENO)
dup2(pipe.fileHandleForReading.fileDescriptor,
     STDIN_FILENO)

pipe.fileHandleForReading.readabilityHandler = { handle in
    let data = handle.availableData
    let str = String(data: data, encoding: .utf8) ?? "[*] <Non-text data of size\(data.count)>\n"
    DispatchQueue.main.async {
        OutPipe.shared.output += str
    }
}

pipe.fileHandleForReading.readabilityHandler = { handle in
    let data = handle.availableData
    let str = String(data: data, encoding: .utf8) ?? "[!] <Non-text data of size\(data.count)>\n"
    DispatchQueue.main.async {
        OutPipe.shared.output += str
    }
}

let genericLogger = Logger(subsystem: "com.bomberfish.FFmpreg", category: "generic")

FFmpregApp.main()
