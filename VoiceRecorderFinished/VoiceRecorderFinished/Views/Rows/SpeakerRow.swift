//
//  SpeakerRow.swift
//  VoiceRecorderFinished
//
//  Created by Kishan Arava on 28/8/21.
//  Copyright © 2021 Andreas Schultz. All rights reserved.
//

import SwiftUI

struct SpeakerRow: View {
    let recordingPart: RecordingPart
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Speaker \(recordingPart.speakerTag)")
                Spacer()
                
                Image(systemName: "play.circle")
            }
            
            Text(recordingPart.startTime.formatDuration() + " - " + recordingPart.endTime.formatDuration())
        }
    }
}

//struct SpeakerRow_Previews: PreviewProvider {
//    static var previews: some View {
//        SpeakerRow()
//    }
//}
