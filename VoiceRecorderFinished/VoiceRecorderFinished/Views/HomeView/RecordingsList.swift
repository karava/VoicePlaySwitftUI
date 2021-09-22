//RecordingsList.swift

//Created by BLCKBIRDS on 28.10.19.
//Visit www.BLCKBIRDS.com for more.

import SwiftUI

struct RecordingsList: View {
    @ObservedObject var audioRecorder: AudioRecorderVM
    let recordings: FetchedResults<Recording>
    
    var body: some View {
        List {
            ForEach(recordings, id: \.createdAt) { (recording: Recording) in
                NavigationLink(destination: RecordingDetail(recording: recording)) {
                    Text(recording.fileName)
                }
            }
            .onDelete(perform: delete)
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    func delete(at offsets: IndexSet) {
        
        var urlsToDelete = [URL]()
        for index in offsets {
            urlsToDelete.append(audioRecorder.recordings[index].fileURL)
        }
        audioRecorder.deleteRecording(urlsToDelete: urlsToDelete)
    }
}

//struct RecordingsList_Previews: PreviewProvider {
//    static var previews: some View {
//        RecordingsList(audioRecorder: AudioRecorderVM(), recordings: <#FetchedResults<Recording>#>)
//    }
//}
