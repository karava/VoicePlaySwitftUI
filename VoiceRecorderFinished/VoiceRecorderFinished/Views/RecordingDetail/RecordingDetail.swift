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
    
//    @FetchRequest(entity: RecordingPart.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \.startTime, ascending: true)])
//    private var recordingParts: ResultsRecordingPart] = []
    
    var formattedDate: String {
        let recordingDate = recording.createdAt
        let df = DateFormatter()
        df.dateFormat = "d MMM yyyy"
        
        return df.string(from: recordingDate)
    }
    
    var body: some View {
        VStack {
            Text(recording.fileName)
            HStack {
                Text(formattedDate)
                Spacer()
                Text((audioPlayerVM.audioPlayer?.duration ?? 0).formatDuration())
            }
            .padding()
            
            Slider(value: $audioPlayerVM.sliderValue,
                   in: 0...(audioPlayerVM.audioPlayer?.duration ?? 0),
                   onEditingChanged: { isSliding in
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
            
            
            if audioPlayerVM.isLoading {
                ProgressView()
            } else if recording.recordingParts?.count == 0 {
                Button("Get speaker parts") {
                    self.audioPlayerVM.getSpeakerParts(audioURL: recording.fileURL, recording: recording) { result in
                        switch result {
                        case .success(let parts):
                            parts.forEach { recordingPart in
                                self.recording.addToRecordingParts(recordingPart)
                            }
                        case .failure(let error):
                            break
                        }
                    }
                }
            } else {
                List(Array(recording.recordingParts as! Set<RecordingPart>)) { recordingPart in
                    Button {
                        audioPlayerVM.seek(from: recordingPart.startTime, to: recordingPart.endTime)
                    } label: {
                        SpeakerRow(recordingPart: recordingPart)

                    }
                    .foregroundColor(.black)
                }
                .listStyle(InsetGroupedListStyle())
            }
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
