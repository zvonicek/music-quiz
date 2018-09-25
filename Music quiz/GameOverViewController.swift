//
//  GameOverViewController.swift
//  Music quiz
//
//  Created by Adam Amran on 25/09/2018.
//  Copyright © 2018 The Funtasty. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {
    
    @IBOutlet weak var playlistCover: UIImageView!
    @IBOutlet weak var finalScore: UILabel!
    @IBOutlet weak var bestScore: UILabel!
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var backToSelectionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tryAgainButton.layer.cornerRadius = 30
        self.backToSelectionButton.layer.cornerRadius = 30
        self.backToSelectionButton.layer.borderColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.backToSelectionButton.layer.borderWidth = 2
    }
}
