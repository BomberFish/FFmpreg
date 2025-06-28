// bomberfish
// main.swift – FFmpreg
// created on 2025-05-08

import Foundation
import SwiftUICore
import OSLog

//var descriptor: UnsafeMutablePointer<UnsafePointer<AVCodecDescriptor>?>?

//print(get_codecs_sorted(&descriptor))
//
//
//if let cstr = descriptor.unsafelyUnwrapped.pointee?.pointee.name {
//    print(String(cString: cstr))
//}

print_codecs(03)

var consolePipe = Pipe()

//setvbuf(stdout, nil, _IONBF, 0)
//setvbuf(stderr, nil, _IONBF, 0)

dup2(consolePipe.fileHandleForWriting.fileDescriptor,
     STDOUT_FILENO)
dup2(consolePipe.fileHandleForWriting.fileDescriptor,
     STDERR_FILENO)
dup2(consolePipe.fileHandleForReading.fileDescriptor,
     STDIN_FILENO)

//let genericLogger = Logger(subsystem: "com.bomberfish.FFmpreg", category: "generic")

FFmpregApp.main()
