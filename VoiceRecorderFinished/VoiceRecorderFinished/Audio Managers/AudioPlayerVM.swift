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
    
    func getSpeakerParts(audioURL: URL) {
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(audioURL, withName: "file")
        }, to: "http://localhost:5000/speakers")
        .responseJSON { response in
            
            switch response.result {
            case .success:
                debugPrint(response)
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
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
