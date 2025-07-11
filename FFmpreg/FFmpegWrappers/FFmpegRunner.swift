// bomberfish
// FFmpegRunner.swift – FFmpreg
// created on 2025-05-08

import Foundation

/// A wrapper for our embedded FFmpeg binary.
class FFmpegRunner {
    /// Generic options
    var options: [String]
    /// Options for the input file
    var infileOptions: [String]
    /// The input file
    var infile: URL
    /// Options for the output file
    var outfileOptions: [String]
    /// The output file
    var outfile: URL
    
    init(options: [String], infileOptions inopt: [String], infile: URL, outfileOptions outopt: [String], outfileName: String?) {
        self.options = options
        self.infileOptions = inopt
        self.infile = infile
        self.outfileOptions = outopt
        self.outfile = URL.documentsDirectory.appendingPathComponent(UUID().uuidString).appendingPathComponent(outfileName ?? infile.lastPathComponent)
    }
    
    init(options: [String], infileOptions inopt: [String], infile: URL, outfileOptions outopt: [String], outfile: URL) {
        self.options = options
        self.infileOptions = inopt
        self.infile = infile
        self.outfileOptions = outopt
        self.outfile = outfile
    }
    
    init(options: [any FFmpegArgument], infileOptions inopt: [any FFmpegArgument], infile: URL, outfileOptions outopt: [any FFmpegArgument], outfileName: String?) {
        self.options = []
        for arg in options {
            self.options += arg.toArguments()
        }
        
        self.infileOptions = []
        for arg in inopt {
            self.infileOptions += arg.toArguments()
        }
        
        self.infile = infile
        
        self.outfileOptions = []
        for arg in outopt {
            self.outfileOptions += arg.toArguments()
        }
        let uuid = UUID().uuidString
        try? FileManager.default.createDirectory(at: URL.documentsDirectory.appendingPathComponent(uuid), withIntermediateDirectories: true)
        self.outfile = URL.documentsDirectory.appendingPathComponent(uuid).appendingPathComponent(outfileName ?? infile.lastPathComponent)
    }
    
    init(options: [any FFmpegArgument], infileOptions inopt: [any FFmpegArgument], infile: URL, outfileOptions outopt: [any FFmpegArgument], outfile: URL) {
        self.options = []
        for arg in options {
            self.options += arg.toArguments()
        }
        
        self.infileOptions = []
        for arg in inopt {
            self.infileOptions += arg.toArguments()
        }
        
        self.infile = infile
        
        self.outfileOptions = []
        for arg in outopt {
            self.outfileOptions += arg.toArguments()
        }
        
        self.outfile = outfile
    }
    
    /// Initializes with a list of arguments
    init(arguments: [String]) {
        // usage: ffmpeg [options] [[infile options] -i infile]... {[outfile options] outfile}...
        
        var args = arguments
        if args[0] == "ffmpeg" {
            args.removeFirst()
        }
        
        let index = args.firstIndex(of: "-i") ?? args.count
        self.options = Array(args[0..<index])
        self.infileOptions = [] // doesn't really matter, it all gets smashed together in the end
        self.infile = URL(fileURLWithPath: args[index + 1])
        self.outfileOptions = Array(args[index + 2..<(args.count - 1)])
        
        let outFile = URL(fileURLWithPath: args.last!)
        self.outfile = URL.documentsDirectory.appendingPathComponent(outFile.lastPathComponent)
    }
    
    /// Initializes with a command line string
    convenience init(cmdLine: String) {
        self.init(arguments: cmdLine.split(separator: " ").map { String($0) })
    }
    
    /// Creates a workable FFmpeg command. Capiche?
    private func constructCommand() -> [String] {
        var command: [String] = ["ffmpeg"]
        
        command += options
        command += infileOptions
        command.append("-i")
        command.append(infile.path)
        command += outfileOptions
        command.append(outfile.path)
        return command
    }
    
    /// Run FFmpeg.
    @discardableResult func run() throws -> Int32 {
        // get our ffmpeg command
        let command: [String] = constructCommand()
        
        // ask politely for our file
        guard infile.startAccessingSecurityScopedResource() else {
            throw "Failed to access resource"
        }
        _ = outfile.deletingLastPathComponent().startAccessingSecurityScopedResource()
        
        // some c-adjacent shenanigans
        let argc = Int32(command.count)
        let argv = UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>.allocate(capacity: Int(argc))
        
        defer {
            // prevent the system from eventually being fussy after repeated use
            // https://developer.apple.com/documentation/foundation/nsurl/startaccessingsecurityscopedresource()
            infile.stopAccessingSecurityScopedResource()
            outfile.deletingLastPathComponent().stopAccessingSecurityScopedResource()
                
            // be a responsible citizen and free our memory...
            for i in 0..<argc {
                free(argv[Int(i)])
            }
            argv.deallocate()
        }
        
        // moar c-adjacent shenanigans
        for i in 0..<argc {
            let arg = String(command[Int(i)])
            argv[Int(i)] = strdup(arg)
        }
        
        print("\(command.joined(separator: " "))")
        
        // run ffmpr- i mean ffmpeg
        return FFmpeg_main(argc, argv)
    }
}


#if targetEnvironment(simulator) || targetEnvironment(macCatalyst)
func FFmpeg_main(_ argc: Int32, _ argv: UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>) -> Int32 {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/local/opt/ffmpeg/bin/ffmpeg")
    process.arguments = (0..<argc).map { String(cString: argv[Int($0)]) }
    process.standardOutput = consolePipe
    process.standardError = consolePipe
    process.standardInput = consolePipe
}
#endif
