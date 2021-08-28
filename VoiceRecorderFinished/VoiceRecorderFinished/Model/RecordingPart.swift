//
//  RecordingPart.swift
//  VoiceRecorderFinished
//
//  Created by Kishan Arava on 28/8/21.
//  Copyright © 2021 Andreas Schultz. All rights reserved.
//

import Foundation

struct RecordingPart: Identifiable {
    let id: String = UUID().uuidString
    
    let speakerTag: Int
    let startTime: Double
    let endTime: Double
    
    static var DUMMY_RECORDING_PARTS: [RecordingPart] = [
        .init(speakerTag: 1, startTime: 0, endTime: 4),
        .init(speakerTag: 2, startTime: 4, endTime: 8),
        .init(speakerTag: 1, startTime: 8, endTime: 10),
        .init(speakerTag: 2, startTime: 11, endTime: 13),
    ]
}
