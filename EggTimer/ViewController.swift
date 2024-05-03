//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer?
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var titleStatus: UILabel!
    var timer: Timer?
    var totalTime = 0 // Total time in seconds
    var timePassed = 0 // Total time in seconds
    let eggTimes = ["Soft": 5, "Medium": 7, "Hard": 12]
    
    override func viewDidLoad() {
            super.viewDidLoad()
            setupAudio()
            configureAudioSession()
        }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        timer?.invalidate()
        let hardness = sender.currentTitle!
        totalTime = eggTimes[hardness]!
        timePassed = 0
        titleStatus.text = "How do you like your eggs?"
        print("Boiling time should be \(eggTimes[hardness]!) seconds.")
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        }
    
    @objc func updateTimer() {
            if timePassed < totalTime {
                timePassed += 1
                progressBar.progress = Float(timePassed)/Float(totalTime)
                print(timePassed)
            } else {
                timer?.invalidate()
                // Optionally, you can add code to perform an action when the timer reaches 0
                print("Time's up!")
                titleStatus.text = "Done!"
                if let player = audioPlayer {
                    if player.isPlaying {
                        player.stop()
                        player.currentTime = 0
                    }
                    player.play()}
            }
        }
    
    func setupAudio() {
            if let soundFilePath = Bundle.main.path(forResource: "alarm_sound", ofType: "mp3") {
                let soundFileURL = URL(fileURLWithPath: soundFilePath)

                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: soundFileURL)
                } catch {
                    print("Error loading sound file: \(error.localizedDescription)")
                }
            } else {
                print("Sound file not found")
            }
        }
    
    func configureAudioSession() {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .mixWithOthers)
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print("Error configuring audio session: \(error.localizedDescription)")
            }
        }
    }

