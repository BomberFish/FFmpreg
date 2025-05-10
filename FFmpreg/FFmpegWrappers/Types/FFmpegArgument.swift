// bomberfish
// FFmpegArgument.swift – FFmpreg
// created on 2025-05-09

import Foundation

enum FFmpegArgumentType {
    case generic,infile,outfile,custom
}

protocol FFmpegArgument: Identifiable, Hashable {
    /// The unique identifier for this argument
    var id: UUID { get }
    /// The command line flag/switch for this argument
    var flag: String { get }
    /// The command line value for this argument. Can be changed by the user
    var value: String { get set }
    /// The name to display in the UI
    var name: String { get }
    /// The icon to display in the UI
    var icon: String { get }
    /// Information about this argument
    var help: String { get }
    /// The type of this argument
    var type: FFmpegArgumentType { get }
    /// Converts the argument to an array of strings for command line execution.
    func toArguments() -> [String]
}

extension FFmpegArgument {
    func toArguments() -> [String] {
        var args: [String] = []
        args.append(flag)
        if !value.isEmpty {
            args.append(value)
        }
        return args
    }
}


struct CustomFFmpegArgument: FFmpegArgument {
    let id = UUID()
    let flag: String = ""
    var value: String = ""
    let name: String = "Custom Argument"
    let icon: String = "wrench.adjustable.fill"
    let help: String = "Custom argument for FFmpeg."
    let type: FFmpegArgumentType = .custom
    
    func toArguments() -> [String] {
        value.split(separator: " ").map { String($0) }
    }
}
