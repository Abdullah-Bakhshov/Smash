//
//  HighlightClip.swift
//  Smash
//
//  Created by Abdullah B on 25/11/2024.
//

import Foundation
import AVFoundation


struct HighlightClip {
    
    init () {}
    
    
    
    func cropandexport(highlight: [Int], videoURL: URL) async {
        
        let manager = FileManager.default
        
        let documentDirectory = try? manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let mediaType = "mp4"
        let asset = AVURLAsset(url: videoURL)
        
        let start = highlight[0]
        let end = highlight[1]
        
        var outputURL = documentDirectory!.appendingPathComponent("output")
        do {
            try manager.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
            outputURL = outputURL.appendingPathComponent("\(UUID().uuidString).\(mediaType)")
        }catch let error {
            print(error)
        }
        
        //Remove existing file
        _ = try? manager.removeItem(at: outputURL)
        
        
        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)
        exportSession!.outputURL = outputURL
        exportSession!.outputFileType = .mp4
        
        let startTime = CMTime(seconds: Double(start), preferredTimescale: 1000)
        let endTime = CMTime(seconds: Double(end), preferredTimescale: 1000)
        let timeRange = CMTimeRange(start: startTime, end: endTime)
        
        exportSession!.timeRange = timeRange
        try? await exportSession!.export(to: outputURL, as: .mp4)
        Task {
            await ClientForAPI().sendvideo(path: outputURL, route: "https://cd91-2a00-23c5-a94-7301-7d80-4265-b6cb-fc8f.ngrok-free.app/uploading_to_ml_model", httpmethod: "POST")
        }
    }
}
