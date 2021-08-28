//AudioPlayer.swift

//Created by BLCKBIRDS on 29.10.19.
//Visit www.BLCKBIRDS.com for more.

import Foundation
import SwiftUI
import AVFoundation

class AudioPlayerVM: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    @Published var isPlaying = false
    @Published var audioPlayer: AVAudioPlayer!
    
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
            isPlaying = true
        } catch {
            print("Playback failed.")
        }
    }
    
    func stopPlayback() {
        audioPlayer.stop()
        isPlaying = false
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
        }
    }
    
}