//
//  QuizViewController.swift
//  Music quiz
//
//  Created by Patrik Potoček on 25.9.18.
//  Copyright © 2018 The Funtasty. All rights reserved.
//

import UIKit

struct QuizState {
    let originalTracks: [Track]
    var remainingTracks: [Track]
    var points: Float
}

class QuizViewController: UIViewController, AudioControllerDelegate {
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var answer0: UIButton!
    @IBOutlet weak var answer1: UIButton!
    @IBOutlet weak var answer2: UIButton!
    @IBOutlet weak var answer3: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var progressConstraint: NSLayoutConstraint!

    var state: QuizState?

    let trackDuration: Float = 10.0
    var pastDuration: Float = 0.0

    let numberOfTracks = 10
    var isPlaying = false
    var correctAnswerIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            SpotifyAPI.sharedInstance.getPlaylist(playlistId: "37i9dQZF1DWWGFQLoP9qlv") { (playlist:Playlist) in
                
                var targetTracks = playlist.tracks
                targetTracks.shuffle()
                targetTracks = Array(targetTracks.prefix(self.numberOfTracks))

                self.state = QuizState(originalTracks: targetTracks, remainingTracks: targetTracks, points: 0)
                self.loadRandomSong()
            }
        }
        
        AudioController.sharedInstance.delegate = self
    }

    func loadRandomSong() {
        if let track = state?.remainingTracks.popLast() {
            if let artist = track.artists.first {
                artist.loadSimilarArtist {
                    self.changeTrack(track: track, artist: artist)
                }
            }
        } else {
            // TODO: finish quiz
        }
    }

    func changeTrack(track:Track, artist: Artist) {
        AudioController.sharedInstance.playPreview(URLString: track.previewURL!)

        DispatchQueue.main.async {
            var artists = [artist.name, artist.similarArtists[0].name, artist.similarArtists[1].name, artist.similarArtists[2].name]
            artists.shuffle()
            self.answer0.setTitle(artists[0], for: .normal)
            self.answer1.setTitle(artists[1], for: .normal)
            self.answer2.setTitle(artists[2], for: .normal)
            self.answer3.setTitle(artists[3], for: .normal)

            self.correctAnswerIndex = artists.index(of: artist.name)!
        }
    }

    func modifySlider(seconds: Float) {
        pastDuration = seconds

        if seconds > trackDuration && isPlaying {
            selectAnswer(nil)
            return
        }

        isPlaying = true

        let progress = view.frame.width - CGFloat(seconds / trackDuration) * view.frame.width
        progressConstraint.constant = progress
    }

    private func selectAnswer(_ selectedIndex: Int?) {
        AudioController.sharedInstance.pauseAudio()
        isPlaying = false

        let buttons = [answer0, answer1, answer2, answer3]
        buttons[correctAnswerIndex]?.setTitleColor(.green, for: .normal)

        if let selectedIndex = selectedIndex, selectedIndex != correctAnswerIndex {
            // incorrect answer
            buttons[selectedIndex]?.setTitleColor(.red, for: .normal)
        } else {
            // correct answer
            state?.points += trackDuration - pastDuration
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            print("load")
            buttons.forEach { button in
                button?.setTitleColor(UIColor.black, for: .normal)
            }

            self.loadRandomSong()
        }
    }

    // MARK: - Button actions

    @IBAction func answer0Tapped(_ sender: Any) {
        selectAnswer(0)
    }

    @IBAction func answer1Tapped(_ sender: Any) {
        selectAnswer(1)
    }

    @IBAction func answer2Tapped(_ sender: Any) {
        selectAnswer(2)
    }

    @IBAction func answer3Tapped(_ sender: Any) {
        selectAnswer(3)
    }
}

