//HomeView.swift

//Created by BLCKBIRDS on 28.10.19.
//Visit www.BLCKBIRDS.com for more.

import SwiftUI

struct HomeView: View {
    @FetchRequest(entity: Recording.entity(),
                  sortDescriptors: [
                    NSSortDescriptor(keyPath: \Recording.createdAt, ascending: true)
                  ])
    private var recordings: FetchedResults<Recording>
    
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var audioRecorder = AudioRecorderVM()
    @State private var showAlert = false
    @State private var textFieldText = ""
    
    var body: some View {
        VStack {
            RecordingsList(audioRecorder: audioRecorder, recordings: self.recordings)
            if audioRecorder.recording == false {
                Button(action: audioRecorder.startRecording) {
                    getStartStopImage(systemName: "circle.fill")
                }
            } else {
                Button(action: {
                    audioRecorder.stopRecording()
                    showTextFieldAlert()
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
    
    func showTextFieldAlert() {
        Alert.titleMessageTextField(
            title: "Change audio name?",
            message: "Do you want to change the audio file name?",
            placeholder: "Type here...",
            defaultText: audioRecorder.fileName!,
            saveActionBtnTitle: "Update") { audioFilename in
            
            do {
                let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                let documentDirectory = URL(fileURLWithPath: path)
                let originPath = documentDirectory.appendingPathComponent("\(audioRecorder.fileName!).m4a")
                let destinationPath = documentDirectory.appendingPathComponent("\(audioFilename).m4a")
                try FileManager.default.moveItem(at: originPath, to: destinationPath)
            } catch {
                print(error)
            }
            
            viewContext.performAndWait {
                self.recordings.last?.fileName = audioFilename
                
                PersistenceController.instance.save()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
