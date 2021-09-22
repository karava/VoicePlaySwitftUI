//AudioRecorderVM.swift

//Created by BLCKBIRDS on 28.10.19.
//Visit www.BLCKBIRDS.com for more.

import Foundation
import SwiftUI
import AVFoundation
import Combine

class AudioRecorderVM: NSObject,ObservableObject {
    
    override init() {
        super.init()
        fetchRecordings()
    }
    
    var audioRecorder: AVAudioRecorder!
    
    @Published var recordings = [Recording]()
    @Published var recording = false
    @Published var fileName: String?
    var creationDate: Date?
    @Environment(\.managedObjectContext) var moc
    
    func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Failed to set up recording session")
        }
        
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        \(Date().toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss"))
        let dateNow = Date()
        let fileName = dateNow.toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss")
        self.creationDate = dateNow
        self.fileName = fileName
        let audioFilenamePath = documentPath.appendingPathComponent(fileName + ".m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilenamePath, settings: settings)
            audioRecorder.record()
            recording = true
            
        } catch {
            print("Could not start recording")
        }
    }
    
    func stopRecording() {
        audioRecorder.stop()
        recording = false
        
        let recording = Recording(context: PersistenceController.instance.container.viewContext)
        recording.fileName = fileName!
            
        recording.createdAt = creationDate!
        PersistenceController.instance.save()
    }
    
    func fetchRecordings() {
        recordings.removeAll()
        
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        for audio in directoryContents {
            print(audio)
//            let recording = Recording(fileURL: audio, createdAt: getCreationDate(for: audio))
//            recordings.append(recording)
        }
        
        recordings.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedDescending})
        
        // objectWillChange.send(self)
    }
    //file:///Users/kishanarava/Library/Developer/CoreSimulator/Devices/614F7BCA-96D7-437B-93C7-DFE9A2F07051/data/Containers/Data/Application/465DCC84-BE32-4CD3-9FA4-D0DBA559679A/Documents/19-09-21_at_19:23:30.m4a
    //file:///Users/kishanarava/Library/Developer/CoreSimulator/Devices/614F7BCA-96D7-437B-93C7-DFE9A2F07051/data/Containers/Data/Application/154F1A3A-8208-44DC-9BE6-B0782BF9D9E9/Documents/19-09-21_at_19:23:30.m4a
    func deleteRecording(urlsToDelete: [URL]) {
        
        for url in urlsToDelete {
            print(url)
            do {
               try FileManager.default.removeItem(at: url)
            } catch {
                print("File could not be deleted!")
            }
        }
        
        fetchRecordings()
    }
    
}
