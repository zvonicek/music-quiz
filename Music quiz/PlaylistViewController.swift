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

    var playlist: Playlist!
    var playlistViewModel: PlaylistViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.playlistCover.layer.cornerRadius = 8
        self.startGameButton.layer.cornerRadius = 30

        playlistCover.downloadedFrom(url: playlistViewModel.image)
        playlistName.text = playlistViewModel.title
        bestScore.text = playlistViewModel.bestScore
    }

    @IBAction func startGame(_ sender: Any) {
        performSegue(withIdentifier: "startGamePush", sender: playlist)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as! QuizViewController).playlist = sender as! Playlist
    }
}
