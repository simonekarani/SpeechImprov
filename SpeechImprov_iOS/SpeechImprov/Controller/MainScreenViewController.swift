//
//  MainScreenViewController.swift
//  SpeechImprov
//
//  Created by Simone Karani on 2/9/20.
//  Copyright © 2020 SpeechAnalyzer. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class MainScreenViewController: UICollectionViewController {
    
    let frontLabelArray = ["Word Therapy", "Story Book", "Speech Practice", "Settings"]
    let frontImageArray = [
        UIImage(named: "wordGame"),
        UIImage(named:"storyBook"),
        UIImage(named: "speechPractice"),
        UIImage(named: "settings")
    ]
    var tablefontSize: Int = 22
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize( width: (self.collectionView.frame.size.width - 20)/2, height: self.collectionView.frame.size.height/4)
        
        print("frame=\(self.view.frame) , width=\(self.view.frame.width), height=\(self.view.frame.height)")
        
        self.navigationItem.setHidesBackButton(true,  animated:true)
        
        let speechSynthesizer = AVSpeechSynthesizer()
        // Line 2. Create an instance of AVSpeechUtterance and pass in a String to be spoken.
        let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: "Welcome to SpeechImprov Application. This application will help you learn vowels. If this was an actual emergency, then this wouldn’t have been a test.")
        
        //Line 3. Specify the speech utterance rate. 1 = speaking extremely the higher the values the slower
        // speech patterns. The default rate, AVSpeechUtteranceDefaultSpeechRate is 0.5
        //speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 4.0
        speechUtterance.rate = 0.4

        // Line 4. Specify the voice.
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        // Line 5. Pass in the urrerance to the synthesizer to actually speak.
        speechSynthesizer.speak(speechUtterance)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return frontImageArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "frontCell", for: indexPath) as! MainScreenCollectionViewCell
        
        cell.frontLabel.text = frontLabelArray[indexPath.item]
        cell.frontImage.image = frontImageArray[indexPath.item]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            UserDefaults.standard.set(0, forKey: "UserSelection")
            if UserDefaults.standard.bool(forKey: "InstrOKN") {
                performSegue(withIdentifier: "gotoOptoKinetic", sender: self)
            }
            else {
                performSegue(withIdentifier: "gotoOKNInstruct", sender: self)
            }
            
        case 1:
            UserDefaults.standard.set(1, forKey: "UserSelection")
            if UserDefaults.standard.bool(forKey: "InstrMovingBall") {
                performSegue(withIdentifier: "gotoMovingBall", sender: self)
            }
            else {
                performSegue(withIdentifier: "gotoMovingBallInstruct", sender: self)
            }
            
        case 2:
            UserDefaults.standard.set(2, forKey: "UserSelection")
            if UserDefaults.standard.bool(forKey: "InstrHitObject") {
                performSegue(withIdentifier: "gotoSpeechPractice", sender: self)
            }
            else {
                performSegue(withIdentifier: "gotoSpeechPractice", sender: self)
                UserDefaults.standard.set(true, forKey: "InstrHitObject")
            }

        case 3:
            UserDefaults.standard.set(3, forKey: "UserSelection")
            if UserDefaults.standard.bool(forKey: "InstrHitObject") {
                performSegue(withIdentifier: "gotoSettings", sender: self)
            }
            else {
                performSegue(withIdentifier: "gotoSettings", sender: self)
                UserDefaults.standard.set(true, forKey: "InstrHitObject")
            }
            
        default:
            performSegue(withIdentifier: "gotoOptoKinetic", sender: self)
        }
    }
    
    @IBAction func backFromUnwind(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
}
