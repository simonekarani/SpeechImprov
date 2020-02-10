//
//  ViewController.swift
//  SpeechImprov
//
//  Created by Simone Karani on 11/2/19.
//  Copyright © 2019 SpeechAnalyzer. All rights reserved.
//

import UIKit
import AVFoundation

// Rev.ai token 02GVy4ZErKZVWt2TrWcZZxbYpyoAbUzyLAu85ar-14HEmMmbKHvDGsueOChXtQ0bPmHeMR3aX0KnznVvWkZNF66ZpqAFc

class AudioRecViewController: UIViewController, AVAudioRecorderDelegate, UITableViewDelegate, UITableViewDataSource {

    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var numberOfRecords:Int = 0
    var audioPlayer:AVAudioPlayer!
    
    @IBOutlet weak var buttonLabel: UIButton!
    
    @IBOutlet weak var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let recCount = UserDefaults.standard.object(forKey: "audioRecordingCount") as? Int {
            numberOfRecords = recCount
        }
        
        // setting up session
        recordingSession = AVAudioSession.sharedInstance()
        
        AVAudioSession.sharedInstance().requestRecordPermission { (hasPermission) in
            if hasPermission {
                print("ACCEPTED")
            }
        }
    }

    @IBAction func record(_ sender: Any) {
        // check if we have active recorder
        if audioRecorder == nil {
            numberOfRecords += 1
            let recFilename = getDirectory().appendingPathComponent("\(numberOfRecords).m4a")
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            
            // start audio recording
            do {
                audioRecorder = try AVAudioRecorder(url: recFilename, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                print(recFilename)
                
                buttonLabel.setTitle("Stop Recording", for: .normal)
            } catch {
                displayAlert(title: "Ops!", message: "Recording Failed. Please Try again...")
            }
        }
        else {
            // stop audio recording
            audioRecorder.stop()
            audioRecorder = nil
            
            UserDefaults.standard.set(numberOfRecords, forKey: "audioRecordingCount")
            myTableView.reloadData()
            
            buttonLabel.setTitle("Start Recording", for: .normal)
        }
    }
    
    
    // function that gets path to diretory for recording file
    func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
    // function that displays an alert
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // setting up table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRecords
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = String(indexPath.row+1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let path = getDirectory().appendingPathComponent("\(indexPath.row+1).m4a")
        print(path)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: path)
            audioPlayer.play()
        } catch {
            
        }
    }
}

