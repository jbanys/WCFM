//
//  StreamViewController.swift
//  WCFM
//
//  Created by Matt Newman on 11/11/18.
//  Copyright © 2018 Matt Newman. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer

/**
 Stream view controller
 */
class StreamViewController: UIViewController {
   
    // MARK: - Outlets
    
    /// outlet for current show label
    @IBOutlet weak var currentShowLabel: UILabel!
    
    /// outlet for next show label
    @IBOutlet weak var nextShowLabel: UILabel!
    
    /// outlet for play button
    @IBOutlet weak var playButton: UIButton!
   
    /// outlet for volume slider
    @IBOutlet weak var volumeSlider: UISlider!
    
    // show cover image
    @IBOutlet weak var coverImage: UIImageView!
    
    // MARK: - Private Implementation
    
    /// AV player
    private var player: AVPlayer?
    
    /// whether or not the stream is playing
    private var isplaying : Bool = false
    
    /// whether or not the stream is up
    private var online : Bool = true
    
    /// URL of stream
    private let streamURLString = "http://137.165.206.193:8000/stream"
    
    // audio session
    private var audioSession = AVAudioSession.sharedInstance()
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateLabels()
        if verifyUrl(urlString: streamURLString) {
            streamUp()
        } else {
            streamDown()
        }
    }
    
    // MARK: - Stream Control
    
    /// start stream
    private func start() {
        if verifyUrl(urlString: streamURLString) {
            let streamURL = URL.init(string: streamURLString)!
            let playerItem: AVPlayerItem = AVPlayerItem(url: streamURL)
            player = AVPlayer(playerItem: playerItem)
            try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            player?.play()
            playButton.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
        } else {
            streamDown()
        }
    }
    
    /// stop stream
    private func stop() {
        player = nil
        playButton.setImage(UIImage(named: "play"), for: UIControl.State.normal)
    }
    
    /// start/stop stream
    @IBAction func togglePlay(_ sender: UIButton) {
        if online {
            if isplaying {
                stop()
            } else {
                start()
            }
            isplaying = !isplaying
        }
    }
    
    /// Returns whether or not the given String is a valid URL
    private func verifyUrl(urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = URL(string: urlString) {
                return UIApplication.shared.canOpenURL(url)
            }
        }
        return false
    }
    
    // MARK: - UI
    
    /// Updates the current show and up next show labels according to the Schedule
    private func updateLabels() {
        // currentRadioShow
        if let currentRadioShow = Schedule.instance.getCurrentRadioShow() {
            let attributes1 = [
                // NSAttributedString.Key.foregroundColor: UIColor.blue,
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)
            ]
            let attributedString1 = NSMutableAttributedString(string: currentRadioShow.title, attributes: attributes1)
            let atrributedString2 = NSAttributedString(string: "\n\(currentRadioShow.hosts)")
            attributedString1.append(atrributedString2)
            currentShowLabel.attributedText = attributedString1
            if let imageURL = currentRadioShow.imageURL {
                DispatchQueue.global().async { [weak self] in
                    let imageData = try? Data(contentsOf: imageURL)
                    DispatchQueue.main.async {
                        if let data = imageData {
                            self?.coverImage.image = UIImage(data: data)
                        }
                    }
                }
            }
        } else {
            currentShowLabel.text = "Now Playing: none"
        }
        // nextRadioShow
        let nextRadioShow = Schedule.instance.getNextRadioShow()
        let attributedString1 = NSMutableAttributedString(string: "Up Next: ")
        let attributes2 = [
            // NSAttributedString.Key.foregroundColor: UIColor.blue,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)
        ]
        let attributedString2 = NSAttributedString(string: nextRadioShow.title, attributes: attributes2)
        let attributedString3 = NSAttributedString(string: "\n@ \(nextRadioShow.timeDescription)")
        attributedString1.append(attributedString2)
        attributedString1.append(attributedString3)
        nextShowLabel.attributedText = attributedString1
    }
    
    /// stream is up
    private func streamUp() {
        if !online {
            playButton.setImage(UIImage(named: "play"), for: UIControl.State.normal)
        }
        online = true
    }
    
    /// stream is down
    private func streamDown() {
        online = false
        playButton.setImage(UIImage(named: "offline"), for: UIControl.State.normal)
    }
    
    // MARK: - Volume Control
    
    /**
     Updates the player volume based on the slider value
     */
    @IBAction func sliderValueChanged(_ slider: UISlider) {
        player?.volume = slider.value
    }
    
}
