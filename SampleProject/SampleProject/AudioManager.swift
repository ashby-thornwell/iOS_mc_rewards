//
//  AudioManager.swift
//  SampleProject
//
//  Copyright © 2019 ashby thornwell. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation

class AVSessionManager {
    func switchToAmbientAudioCategory() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        } catch {
            print("Error Changing AVSession Category")
        }
    }

    func switchToSoloAmbientAudioCategory() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategorySoloAmbient)
        } catch {
            print("Error Changing AVSession Category")
        }
    }

    func switchToPlayBack() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
            print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                print("AVAudioSession is Active")
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
}
