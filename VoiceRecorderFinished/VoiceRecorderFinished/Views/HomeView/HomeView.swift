//HomeView.swift

//Created by BLCKBIRDS on 28.10.19.
//Visit www.BLCKBIRDS.com for more.

import SwiftUI

struct HomeView: View {
    @StateObject private var audioRecorder = AudioRecorder()
    
    var body: some View {
        NavigationView {
            VStack {
                RecordingsList(audioRecorder: audioRecorder)
                if audioRecorder.recording == false {
                    Button(action: audioRecorder.startRecording) {
                        getStartStopImage(systemName: "circle.fill")
                    }
                } else {
                    Button(action: audioRecorder.stopRecording) {
                        getStartStopImage(systemName: "stop.fill")
                    }
                }
            }
                .navigationBarTitle("Voice recorder")
                .navigationBarItems(trailing: EditButton())
        }
    }
    
    func getStartStopImage(systemName: String) -> some View {
        Image(systemName: systemName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 80, height: 80)
            .clipped()
            .foregroundColor(.red)
            .padding(.bottom, 40)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
