//RecordingsList.swift

//Created by BLCKBIRDS on 28.10.19.
//Visit www.BLCKBIRDS.com for more.

import SwiftUI

struct RecordingsList: View {
    @FetchRequest(entity: Recording.entity(),
                  sortDescriptors: [
                    NSSortDescriptor(keyPath: \Recording.createdAt, ascending: true)
                  ])
    private var recordings: FetchedResults<Recording>
    
    @ObservedObject var audioRecorder: AudioRecorderVM
    
    var body: some View {
        List {
            ForEach(recordings, id: \.createdAt) { (recording: Recording) in
                NavigationLink(destination: RecordingDetail(recording: recording)) {
                    Text(recording.getfileURL().lastPathComponent)
                }
            }
            .onDelete(perform: delete)
        }
    }
    
    func delete(at offsets: IndexSet) {
        
        var urlsToDelete = [URL]()
        for index in offsets {
            urlsToDelete.append(audioRecorder.recordings[index].getfileURL())
        }
        audioRecorder.deleteRecording(urlsToDelete: urlsToDelete)
    }
}

struct RecordingsList_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsList(audioRecorder: AudioRecorderVM())
    }
}
