//
//  PlayerViewController.swift
//  RecordAudio
//
//  Created by Krishna Gunjal on 27/02/23.
//

import UIKit
import Combine
import AVFoundation

class PlayerViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var soundPlayer: AVAudioPlayer?
    var fileName = "audioFile.m4a"
    var filePath: URL?
    var samples = ["Mesage from Bhagyashri Khairnar","Message from Elon Musk",  "Message from Krishna Gunjal", "Message from Manali Kulkarni", "Message from Milan Pansuriya", "Message from Omkar Kulkarni"]
    var disposable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: AudioCell.identifier, bundle: nil), forCellReuseIdentifier: AudioCell.identifier)
        convertAction()
    }
    
    func getDocumentDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    func convertAction() {
//          self.statusLabel.text = "Converting..."
        let input = getDocumentDirectory().appendingPathComponent(fileName)
          let output = getDocumentDirectory().appendingPathComponent("Message from Yogesh Kulkarni.mp3")
        samples.append("Message from Yogesh Kulkarni.mp3")
          let converter = MP3Converter()
//          convertButton.isEnabled = false
          
          /// Run it in a different queue and update the UI when it's done executing, otherwise your UI will freeze.
          DispatchQueue.global(qos: .userInteractive).async {
              converter.convert(input: input, output: output)
                  .receive(on: DispatchQueue.global())
                  .sink(receiveCompletion: { result in
                      DispatchQueue.main.async {
                          if case .failure(let error) = result {
//                              self.statusLabel.text = "Conversion failed: \n\(error.localizedDescription)"
//                              self.convertButton.isEnabled = true
                              print(error)
                          }
                      }
                  }, receiveValue: { result in
                      DispatchQueue.main.async {
//                          let playerItem: AVPlayerItem = AVPlayerItem(url: result)
                          self.filePath = result
//                          self.player = AVPlayer(playerItem: playerItem)
//                          self.player?.play()
                          print("File saved as converted.mp3 in \nthe documents directory.")
                          
                      }
                  }).store(in: &self.disposable)
          }
      }
    
    func convertAction(input:URL) {
          let output = URL(string: "\(input).mp3")
          let converter = MP3Converter()
          DispatchQueue.global(qos: .userInteractive).async {
              converter.convert(input: input, output: output!)
                  .receive(on: DispatchQueue.global())
                  .sink(receiveCompletion: { result in
                      DispatchQueue.main.async {
                          if case .failure(let error) = result {
                              print(error)
                          }
                      }
                  }, receiveValue: { result in
                      DispatchQueue.main.async {
                          self.filePath = result
                          print("File saved as converted.mp3 in \nthe documents directory.")
                          
                      }
                  }).store(in: &self.disposable)
          }
      }
    
    func setupPlayer(input: URL) {
        //change to mp3 filename
//        convertAction(input: input)
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: input)
            soundPlayer?.prepareToPlay()
            soundPlayer?.volume = 1.0
        }catch {
            print(error)
        }
    }
}

extension PlayerViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return samples.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AudioCell") as! AudioCell
        cell.titleLabel.text = samples[indexPath.row]
        cell.buttonTapCallback = {
            cell.button.isSelected = !cell.button.isSelected
            cell.button.isSelected
                ? cell.button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                : cell.button.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let recordingUrl = samples[indexPath.row].hasSuffix(".mp3")
        ? getDocumentDirectory().appendingPathComponent("\(samples[indexPath.row])")
        : getDocumentDirectory().appendingPathComponent("\(samples[indexPath.row]).mp3")
        
        setupPlayer(input: recordingUrl)
        soundPlayer?.play()
    }}
