//
//  RecordingDetail.swift
//  VoiceRecorderFinished
//
//  Created by Kishan Arava on 24/8/21.
//  Copyright © 2021 Andreas Schultz. All rights reserved.
//

import SwiftUI

struct RecordingDetail: View {
    var audioURL: URL
    @StateObject var audioPlayerVM: AudioPlayerVM = AudioPlayerVM()
    
    var body: some View {
        VStack {
            Text(audioURL.lastPathComponent)
            Text("\(audioPlayerVM.audioPlayer?.duration ?? 0)")
            
            if audioPlayerVM.isPlaying == false {
                Button(action: {
                    self.audioPlayerVM.startPlayback(audio: self.audioURL)
                }) {
                    Image(systemName: "play.circle")
                        .imageScale(.large)
                }
            } else {
                Button(action: {
                    self.audioPlayerVM.stopPlayback()
                }) {
                    Image(systemName: "stop.fill")
                        .imageScale(.large)
                }
            }
        }
        .onAppear {
            self.audioPlayerVM.startPlayback(audio: self.audioURL)
        }
    }
}

//struct RecordingDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        RecordingDetail(audioURL: URL, audioPlayer: AudioPlayer())
//    }
//}
