//
//  GameOverViewController.swift
//  Music quiz
//
//  Created by Adam Amran on 25/09/2018.
//  Copyright © 2018 The Funtasty. All rights reserved.
//

import UIKit
import AVFoundation

class GameOverViewController: UIViewController {
    
    @IBOutlet weak var playlistCover: UIImageView!
    @IBOutlet weak var finalScore: UILabel!
    @IBOutlet weak var bestScore: UILabel!
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var backToSelectionButton: UIButton!
    
    var soundPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tryAgainButton.layer.cornerRadius = 30
        self.backToSelectionButton.layer.cornerRadius = 30
        self.backToSelectionButton.layer.borderColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.backToSelectionButton.layer.borderWidth = 2
    }
    
    func playSuccessSound() {
        guard let url = Bundle.main.url(forResource: "success", withExtension: "m4a") else { return }
        soundPlayer = try! AVAudioPlayer(contentsOf: url)
        soundPlayer?.prepareToPlay()
        soundPlayer?.play()
        
    }
    @IBAction func tryAgainButton(_ sender: Any) {
        playSuccessSound()
    }
}
