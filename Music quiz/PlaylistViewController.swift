//
//  PlaylistViewController.swift
//  Music quiz
//
//  Created by Adam Amran on 25/09/2018.
//  Copyright © 2018 The Funtasty. All rights reserved.
//

import UIKit

class PlaylistViewController: UIViewController {
    
    @IBOutlet weak var playlistCover: UIImageView!
    @IBOutlet weak var playlistName: UILabel!
    @IBOutlet weak var bestScore: UILabel!
    @IBOutlet weak var startGameButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playlistCover.layer.cornerRadius = 8
        self.startGameButton.layer.cornerRadius = 30
    }
}
