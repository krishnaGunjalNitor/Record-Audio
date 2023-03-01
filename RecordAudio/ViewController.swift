//
//  ViewController.swift
//  RecordAudio
//
//  Created by Krishna Gunjal on 23/02/23.
//

import UIKit
import AVFoundation
import Combine

class ViewController: UIViewController, AVAudioRecorderDelegate{

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var goToPlayPageButton: UIButton!
    
    var soundRecorder: AVAudioRecorder?
    var soundPlayer: AVAudioPlayer?
    var fileName = "audioFile.m4a"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        askPermissionIfNeeded()
        goToPlayPageButton.isEnabled = false
    }
    
    func askPermissionIfNeeded() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .undetermined:
            askMicrophoneAuthorization()
        case .denied:
            let alert = UIAlertController(title: "Error", message: "Please allow microphone usage from settings", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Open settings", style: .default, handler: { action in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        case .granted:
            setupRecorder()
        }
    }
    
    func askMicrophoneAuthorization() {
        AVAudioSession.sharedInstance().requestRecordPermission({ granted in
                    // Handle granted
            self.setupRecorder()
                })
    }
    
    func getDocumentDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    func setupRecorder() {
        let audioFileName = getDocumentDirectory().appendingPathComponent(fileName)
        let recordSettings = [AVFormatIDKey: kAudioFormatAppleLossless, AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue, AVEncoderBitRateKey: 32000, AVNumberOfChannelsKey: 2, AVSampleRateKey: 44100.2] as [String: Any]
        do {
            soundRecorder = try AVAudioRecorder(url: audioFileName, settings: recordSettings)
            soundRecorder?.delegate = self
            soundRecorder?.prepareToRecord()
        }catch {
            print(error)
        }
    }

    @IBAction func recordButtonTapped(_ sender: Any) {
        if recordButton.titleLabel?.text == "Record" {
            soundRecorder?.record()
            recordButton.setTitle("Stop", for: .normal)
            goToPlayPageButton.isEnabled = false
            goToPlayPageButton.isUserInteractionEnabled = false
        }else {
            soundRecorder?.stop()
            recordButton.setTitle("Record", for: .normal)
            goToPlayPageButton.isEnabled = true
            goToPlayPageButton.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func GoToPlayerView(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PlayerViewController") as? PlayerViewController
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
}

