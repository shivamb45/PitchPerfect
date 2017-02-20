//
//  RecordAudio.swift
//  PitchPerfect
//
//  Created by Shivam Bharadwaj on 31/10/16.
//  Copyright © 2016 Shivam Bharadwaj. All rights reserved.
//

import UIKit
import AVFoundation

class RecordAudio : UIViewController, AVAudioRecorderDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        stopRecordingButton.isHidden=true
        stopRecordingButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     @IBOutlet weak var recordingLabel: UILabel!
    
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    @IBOutlet weak var startRecordingButton: UIButton!
    var audioRecorder:AVAudioRecorder!
    @IBAction func recordAudio(_ sender: Any) {
        print("Recording...")
        recordingLabel.text = "Recording in Progress. Tap to Stop"
        stopRecordingButton.isEnabled = true
        stopRecordingButton.isHidden=false
        startRecordingButton.isEnabled = false
        startRecordingButton.isHidden = true
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        let recordingName = "voice.wav"
        let pathArray = [dirPath,recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        print(filePath!)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        
    }
    @IBAction func stopRecording(_ sender: Any) {
        print("Stop recording started...")
        recordingLabel.text = "Tap to Record"
        startRecordingButton.isEnabled = true
        stopRecordingButton.isEnabled = false
        stopRecordingButton.isHidden = true
        startRecordingButton.isHidden = false
        audioRecorder.stop()
        let audiosession = AVAudioSession.sharedInstance()
        try! audiosession.setActive(false)
        
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Recording is finished")
        if(flag)
        {
            self.performSegue(withIdentifier: "stopRecordingSeg", sender: audioRecorder.url)
        }
        else
        {
            print("Recording FAILED!!")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "stopRecordingSeg")
        {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURL
            
        }
    }

}

