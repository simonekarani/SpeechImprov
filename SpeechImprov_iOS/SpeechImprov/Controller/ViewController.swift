//
//  ViewController.swift
//  SpeechImprov
//
//  Created by Simone Karani on 11/3/19.
//  Copyright © 2019 SpeechAnalyzer. All rights reserved.
//

import UIKit
import Speech
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {

    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var numberOfRecords:Int = 0
    var audioPlayer:AVAudioPlayer!
    var recFilename:URL!

    @IBOutlet weak var transcriptionTextField: UITextView!
    
    @IBOutlet weak var recButton: CircleButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.stop()
    }
    
    func requestSpeechAuth() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            if authStatus == SFSpeechRecognizerAuthorizationStatus.authorized {
                if self.recFilename != nil {
                    do {
                        let sound = try AVAudioPlayer(contentsOf: self.recFilename)
                        self.audioPlayer = sound
                        self.audioPlayer.delegate = self
                        sound.play()
                    } catch {
                        print("Error")
                    }
                    
                    let recognizer = SFSpeechRecognizer()
                    let request = SFSpeechURLRecognitionRequest(url: self.recFilename)
                    recognizer?.recognitionTask(with: request) { (result, error) in
                        if let error = error {
                            print("There was an error: \(error)")
                        } else {
                            self.transcriptionTextField.text = result?.bestTranscription.formattedString
                        }
                    }
                }
            }
        }
    }
    
    // function that gets path to diretory for recording file
    func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }

    @IBAction func recordButtonPressed(_ sender: Any) {
        // check if we have active recorder
        if audioRecorder == nil {
            numberOfRecords += 1
            recFilename = getDirectory().appendingPathComponent("recording.m4a")
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            
            // start audio recording
            do {
                audioRecorder = try AVAudioRecorder(url: recFilename, settings: settings)
                audioRecorder.delegate = self as? AVAudioRecorderDelegate
                audioRecorder.record()
                recButton.setTitle("Stop", for: .normal)
                print(recFilename)
                
            } catch {
                displayAlert(title: "Ops!", message: "Recording Failed. Please Try again...")
            }
        }
        else {
            // stop audio recording
            audioRecorder.stop()
            audioRecorder = nil
            
            recButton.setTitle("Rec", for: .normal)
            UserDefaults.standard.set(numberOfRecords, forKey: "audioRecordingCount")
        }
    }

    // function that displays an alert
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        requestSpeechAuth()
    }
}
