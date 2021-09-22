//AudioPlayer.swift

//Created by BLCKBIRDS on 29.10.19.
//Visit www.BLCKBIRDS.com for more.

import Foundation
import SwiftUI
import AVFoundation
import Alamofire

class AudioPlayerVM: NSObject, ObservableObject {
    
    @Published var isPlaying = false
    @Published var audioPlayer: AVAudioPlayer!
    @Published var sliderValue: Double = 0
    @Published var isLoading = false
    
    var timer: Timer?
    
    func startPlayback(audio: URL) {
        
        let playbackSession = AVAudioSession.sharedInstance()
        
        do {
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Playing over the device's speakers failed")
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audio)
            audioPlayer.delegate = self
            audioPlayer.play()
            startTimer()
            
        } catch {
            print("Playback failed.")
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
        isPlaying = true
    }
    
    @objc
    func updateSlider() {
        sliderValue = audioPlayer.currentTime
    }
    
    func stopPlayback() {
        audioPlayer.stop()
        timer?.invalidate()
        isPlaying = false
    }
    
    func scrubTime(_ time: Double? = nil) {
        audioPlayer?.stop()
        audioPlayer?.currentTime = time ?? sliderValue
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
        startTimer()
    }
    
    func seek(from fromSecond: Double, to toSecond: Double) {
        scrubTime(fromSecond)
        DispatchQueue.main.asyncAfter(deadline: .now() + (toSecond - fromSecond)) {
            self.stopPlayback()
        }
    }
    
    func getSpeakerParts(audioURL: URL, recording: Recording, completion: @escaping (_ result: Result<[RecordingPart], Error>) -> Void) {
        isLoading = true
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(audioURL, withName: "file")
        }, to: "http://localhost:5000/speakers")
        .responseJSON { response in
            
            switch response.result {
            case .success(let data):
                let recordingPartsJSON = data as! [NSDictionary]
                
                var recordingPartsArray: [RecordingPart] = []
                
                recordingPartsJSON.forEach { recordingPartJSON in
                    guard
                    let endTime = recordingPartJSON["end_time"] as? Double,
                    let speakerTag = recordingPartJSON["speaker_tag"] as? Int,
                    let startTime = recordingPartJSON["start_time"] as? Double
                    else { completion(.failure(NetworkError.parsingError)); return }
                    
                    let part = RecordingPart(context: PersistenceController.instance.container.viewContext)
                    part.speakerTag = Int16(speakerTag)
                    part.startTime = startTime
                    part.endTime = endTime
                    part.recording = recording
                    recordingPartsArray.append(part)
                }
                
                PersistenceController.instance.save()
                completion(.success(recordingPartsArray))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
            
            self.isLoading = false
        }
    }
}

extension AudioPlayerVM: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
        }
        timer?.invalidate()
        timer = nil
        sliderValue = 0
    }
}
