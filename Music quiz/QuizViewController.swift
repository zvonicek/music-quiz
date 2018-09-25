//
//  QuizViewController.swift
//  Music quiz
//
//  Created by Patrik Potoček on 25.9.18.
//  Copyright © 2018 The Funtasty. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController, AudioControllerDelegate {
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var answer1: UIButton!
    @IBOutlet weak var answer2: UIButton!
    @IBOutlet weak var answer3: UIButton!
    @IBOutlet weak var answer4: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var progressConstraint: NSLayoutConstraint!

    //let playlist: PlaylistViewModel
    var albumTracks = [Track]()
    let trackDuration: Float = 10.0

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            SpotifyAPI.sharedInstance.getPlaylist(userId: "spotify", playlistId: "37i9dQZF1DWWGFQLoP9qlv") { (tracks:[Track]) in
                self.albumTracks = tracks
                // load UI
                self.loadRandomSong()
            }
        }
        
        AudioController.sharedInstance.delegate = self
    }

    func loadRandomSong() {
        if albumTracks.count > 0 {
            let index = Int(arc4random_uniform(UInt32(albumTracks.count) - 1))
            let track = albumTracks[index]
            albumTracks.remove(at: index)

            track.artists.first?.loadSimilarArtist {
                self.changeTrack(track: track)
                DispatchQueue.main.async {
//                    if let urlString = track.album.images.first?.url {
//                        self.albumCoverIV.downloadedFrom(url: URL(string: urlString)!)
//                        self.backgroundIV.downloadedFrom(url: URL(string: urlString)!)
//                    }
//                    self.artistLabel.text = "The xx"
//                    self.trackLabel.text = track.name

                    
                    print(track.name)
                }
            }
        }
    }

    func changeTrack(track:Track) {
        AudioController.sharedInstance.playPreview(URLString: track.previewURL!)
    }

    func modifySlider(seconds: Float) {


        let progress = view.frame.width - CGFloat(seconds / trackDuration) * view.frame.width
        progressConstraint.constant = progress
    }

    // MARK: - Button actions

    @IBAction func answer1Tapped(_ sender: Any) {
    }

    @IBAction func answer2Tapped(_ sender: Any) {
    }

    @IBAction func answer3Tapped(_ sender: Any) {
    }

    @IBAction func answer4Tapped(_ sender: Any) {
    }
}

