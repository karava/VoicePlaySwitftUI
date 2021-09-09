//
//  RecordingDetail.swift
//  VoiceRecorderFinished
//
//  Created by Kishan Arava on 24/8/21.
//  Copyright © 2021 Andreas Schultz. All rights reserved.
//

import SwiftUI

struct RecordingDetail: View {
    var recording: Recording
    @StateObject var audioPlayerVM: AudioPlayerVM = AudioPlayerVM()
    
    var formattedDate: String {
        let recordingDate = recording.createdAt
        let df = DateFormatter()
        df.dateFormat = "d MMM yyyy"
        
        return df.string(from: recordingDate)
    }
    
    var body: some View {
        VStack {
            Text(recording.fileURL.lastPathComponent)
            HStack {
                Text(formattedDate)
                Spacer()
                Text((audioPlayerVM.audioPlayer?.duration ?? 0).formatDuration())
            }
            .padding()
            
            Slider(value: .constant(audioPlayerVM.audioPlayer?.currentTime ?? 0), in: 0...(audioPlayerVM.audioPlayer?.duration ?? 0), onEditingChanged: { isSliding in
                if !isSliding {
                    audioPlayerVM.scrubTime()
                }
            })
            .padding()
            
            HStack {
                Text(audioPlayerVM.sliderValue.formatDuration())
                Spacer()
                Text((audioPlayerVM.audioPlayer?.duration ?? 0).formatDuration())
            }
            .padding()
            
            HStack {
                
                Image(systemName: "gobackward.15")
                
                if audioPlayerVM.isPlaying == false {
                    Button(action: {
                        self.audioPlayerVM.startPlayback(audio: recording.fileURL)
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
                
                Image(systemName: "goforward.15")
            }
            
            Text("Speakers:")
            
            Button("Get speaker parts") {
                self.audioPlayerVM.getSpeakerParts(audioURL: recording.fileURL)
            }
            
            List(RecordingPart.DUMMY_RECORDING_PARTS) { recordingPart in
                Button {
                    audioPlayerVM.seek(from: recordingPart.startTime, to: recordingPart.endTime)
                } label: {
                    SpeakerRow(recordingPart: recordingPart)
                        
                }
                .foregroundColor(.black)
            }
            .listStyle(InsetGroupedListStyle())
        }
        .onAppear {
            self.audioPlayerVM.startPlayback(audio: recording.fileURL)
            // (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.requestFeedback()
        }
    }
}

//struct RecordingDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        RecordingDetail(audioURL: URL, audioPlayer: AudioPlayer())
//    }
//}
