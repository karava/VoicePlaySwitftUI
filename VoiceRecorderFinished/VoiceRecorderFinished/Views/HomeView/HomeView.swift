//HomeView.swift

//Created by BLCKBIRDS on 28.10.19.
//Visit www.BLCKBIRDS.com for more.

import SwiftUI

struct HomeView: View {
    @StateObject private var audioRecorder = AudioRecorderVM()
    @State private var showAlert = false
    @State private var fileName: String?
    @State private var textFieldText = ""
    
    var body: some View {
        VStack {
            RecordingsList(audioRecorder: audioRecorder)
            if audioRecorder.recording == false {
                Button(action: {
                    self.fileName = Date().toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss")
                    audioRecorder.startRecording(audioFilename: fileName!)
                }) {
                    getStartStopImage(systemName: "circle.fill")
                }
            } else {
                Button(action: {
                    Alert.titleMessageTextField(
                        title: "Change audio name?",
                        message: "Do you want to change the audio file name?",
                        placeholder: "Type here...",
                        defaultText: fileName!,
                        saveActionBtnTitle: "Update") { audioFilename in
                        
                        do {
                            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                            let documentDirectory = URL(fileURLWithPath: path)
                            let originPath = documentDirectory.appendingPathComponent("\(fileName!).m4a")
                            let destinationPath = documentDirectory.appendingPathComponent("\(audioFilename).m4a")
                            try FileManager.default.moveItem(at: originPath, to: destinationPath)
                            
                            audioRecorder.fetchRecordings()
                        } catch {
                            print(error)
                        }
                    }
                    
                    audioRecorder.stopRecording()
                }) {
                    getStartStopImage(systemName: "stop.fill")
                }
            }
        }
        .navigationBarTitle("Voice recorder")
        .navigationBarItems(
            leading: NavigationLink(destination: SettingsView()) { Image(systemName:"gear") },
            trailing: EditButton()
        )
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
