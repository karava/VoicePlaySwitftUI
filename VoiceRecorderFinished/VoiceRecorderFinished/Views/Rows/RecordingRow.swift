//
//  RecordingRow.swift
//  VoiceRecorderFinished
//
//  Created by Kishan Arava on 24/8/21.
//  Copyright © 2021 Andreas Schultz. All rights reserved.
//

import SwiftUI

struct RecordingRow: View {
    var audioURL: URL
    
    @ObservedObject var audioPlayer: AudioPlayerVM
    
    var body: some View {
        HStack {
            Text("\(audioURL.lastPathComponent)")
            Spacer()
            if audioPlayer.isPlaying == false {
                Button(action: {
                    self.audioPlayer.startPlayback(audio: self.audioURL)
                }) {
                    Image(systemName: "play.circle")
                        .imageScale(.large)
                }
            } else {
                Button(action: {
                    self.audioPlayer.stopPlayback()
                }) {
                    Image(systemName: "stop.fill")
                        .imageScale(.large)
                }
            }
        }
    }
}

//struct RecordingRow_Previews: PreviewProvider {
//    static var previews: some View {
//        RecordingRow(audioURL: URL(string: "https://www.google.com")!)
//    }
//}
