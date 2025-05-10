// bomberfish
// OutfileOptions.swift – FFmpreg
// created on 2025-05-09

import Foundation

struct VideoCodec: FFmpegArgument {
    var id = UUID()
    let flag: String = "-c:v"
    var value: String = ""
    let name: String = "Video Codec"
    let icon: String = "video"
    let help: String = "The codec to use for the video stream."
    let type: FFmpegArgumentType = .outfile
}

struct VideoBitrate: FFmpegArgument {
    var id = UUID()
    let flag: String = "-b:v"
    var value: String = ""
    let name: String = "Video Bitrate"
    let icon: String = "rectangle.pattern.checkered"
    let help: String = "The bitrate to use for the video stream."
    let type: FFmpegArgumentType = .outfile
}

struct VideoFilter: FFmpegArgument {
    var id = UUID()
    let flag: String = "-filter:v"
    var value: String = ""
    let name: String = "Video Filter"
    let icon: String = "camera.filters"
    let help: String = "The filter to apply to the video stream."
    let type: FFmpegArgumentType = .outfile
}

struct AudioCodec: FFmpegArgument {
    var id = UUID()
    let flag: String = "-c:a"
    var value: String = ""
    let name: String = "Audio Codec"
    let icon: String = "speaker.wave.2"
    let help: String = "The codec to use for the audio stream."
    let type: FFmpegArgumentType = .outfile
}

struct AudioBitrate: FFmpegArgument {
    var id = UUID()
    var flag: String = "-b:a"
    var value: String = ""
    var name: String = "Audio Bitrate"
    var icon: String = "waveform.path"
    var help: String = "The bitrate to use for the audio stream."
    var type: FFmpegArgumentType = .outfile
}

struct AudioFilter: FFmpegArgument {
    var id = UUID()
    let flag: String = "-filter:a"
    var value: String = ""
    let name: String = "Audio Filter"
    let icon: String = "waveform.and.magnifyingglass"
    let help: String = "The filter to apply to the audio stream."
    let type: FFmpegArgumentType = .outfile
}

