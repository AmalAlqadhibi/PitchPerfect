//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Amal Alqadhibi on 14/03/2019.
//  Copyright © 2019 Udatcity. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundsViewController: UIViewController , AVAudioRecorderDelegate{
 var audioRecorder: AVAudioRecorder!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var RecoringLabel: UILabel!
    @IBOutlet weak var RecordTimer: UILabel!
    var time = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    
    @IBAction func recordAudio(_ sender: Any) {
      
        configureUI(isRecording:true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
      try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
      
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])

        audioRecorder.delegate = self
 
        audioRecorder.isMeteringEnabled = true
     
        audioRecorder.prepareToRecord()

        audioRecorder.record()
 
    }
    // MARK: - configureing the UI
    @IBAction func stopRecord(_ sender: Any) {
     configureUI(isRecording: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    func configureUI(isRecording : Bool)  {
        if isRecording{
            RecoringLabel.text = "Recording in Progress"
            recordButton.isEnabled = false
            stopRecordingButton.isEnabled = true
        }else{
            recordButton.isEnabled = true
            RecoringLabel.text = "Tap to Recorod"
            stopRecordingButton.isEnabled = false
        }
    }
    // MARK: - Audio Recorder Delegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording" , sender: audioRecorder.url)
        }
        else {
            // show alert, unsuccessful Recording 
            let alertController = UIAlertController(title: "Oops!", message: "Sorry your Recording was not successful.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
            print("Recording was not successful")
        }
    }
 // MARK: - Prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let playSoundsVC = segue.destination as! playSoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

