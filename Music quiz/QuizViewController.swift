//
//  QuizViewController.swift
//  Music quiz
//
//  Created by Patrik Potoček on 25.9.18.
//  Copyright © 2018 The Funtasty. All rights reserved.
//

import UIKit
import AVFoundation

struct QuizState {
    let originalTracks: [Track]
    var remainingTracks: [Track]
    var points: Float

    var progressText: String {
        return "\(originalTracks.count-remainingTracks.count) / \(originalTracks.count)"
    }
}

class QuizViewController: UIViewController, AudioControllerDelegate {
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var answer0: UIButton!
    @IBOutlet weak var answer1: UIButton!
    @IBOutlet weak var answer2: UIButton!
    @IBOutlet weak var answer3: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var progressConstraint: NSLayoutConstraint!
    @IBOutlet weak var scoreLabel: UILabel!

    var playlist: Playlist!
    var state: QuizState? {
        didSet {
            self.title = state?.progressText
            if let state = state {
                self.scoreLabel.text = "\(Int(state.points))"
            }
        }
    }

    let trackDuration: Float = 10.0
    var pastDuration: Float = 0.0

    let numberOfTracks = 10
    var isPlaying = false
    var correctAnswerIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true

        var playlistTracks = playlist.tracks.filter { $0.previewURL != nil }
        playlistTracks.shuffle()
        let targetTracks = Array(playlistTracks.prefix(self.numberOfTracks))

        self.state = QuizState(originalTracks: targetTracks, remainingTracks: targetTracks, points: 0)
        self.loadRandomSong()
        layoutButtons()
        coverImageView.downloadedFrom(url: playlist.coverUrl!)

        AudioController.sharedInstance.delegate = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if AudioController.sharedInstance.player.rate != 0 {
            AudioController.sharedInstance.pauseAudio()
        }
    }

    func layoutButtons() {
        let buttons = [answer0, answer1, answer2, answer3]
        buttons.forEach {
            $0?.layer.cornerRadius = 30
            $0?.layer.borderColor = #colorLiteral(red: 0.5254901961, green: 0.5254901961, blue: 0.5254901961, alpha: 1)
            $0?.layer.borderWidth = 2
        }
    }

    func loadRandomSong() {
        progressConstraint.constant = 0

        if let track = state?.remainingTracks.popLast() {
            if let artist = track.artists.first {
                artist.loadSimilarArtist {
                    self.changeTrack(track: track, artist: artist)
                }
            }
        } else {
            performSegue(withIdentifier: "gameOverPush", sender: nil)
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

        if let selectedIndex = selectedIndex, selectedIndex != correctAnswerIndex {
            // incorrect answer
            buttons[correctAnswerIndex]?.layer.borderColor = #colorLiteral(red: 0.06663694233, green: 0.7623470426, blue: 0.3990229666, alpha: 1)
            buttons[correctAnswerIndex]?.setTitleColor(#colorLiteral(red: 0.06663694233, green: 0.7623470426, blue: 0.3990229666, alpha: 1), for: .normal)
            buttons[selectedIndex]?.backgroundColor = #colorLiteral(red: 0.7450980392, green: 0.09803921569, blue: 0.06274509804, alpha: 1)
            buttons[selectedIndex]?.layer.borderColor = #colorLiteral(red: 0.7450980392, green: 0.09803921569, blue: 0.06274509804, alpha: 1)
            playActionSound(success: false)
        } else {
            // correct answer
            buttons[correctAnswerIndex]?.backgroundColor = #colorLiteral(red: 0.06663694233, green: 0.7623470426, blue: 0.3990229666, alpha: 1)
            buttons[correctAnswerIndex]?.layer.borderColor = #colorLiteral(red: 0.06663694233, green: 0.7623470426, blue: 0.3990229666, alpha: 1)

            state?.points += (trackDuration - pastDuration) * 10
            playActionSound(success: true)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            print("load")
            buttons.forEach { button in
                button?.backgroundColor = .clear
                button?.setTitleColor(.white, for: .normal)
                button?.layer.borderColor = #colorLiteral(red: 0.5254901961, green: 0.5254901961, blue: 0.5254901961, alpha: 1)
            }

            self.loadRandomSong()
        }
    }

    private func playActionSound(success: Bool) {
        let resource = success ? "success" : "error"

        guard let url = Bundle.main.url(forResource: resource, withExtension: "m4a") else { return }
        let soundPlayer = try! AVAudioPlayer(contentsOf: url)
        soundPlayer.prepareToPlay()
        soundPlayer.play()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as! GameOverViewController).quizState = state
        (segue.destination as! GameOverViewController).playlist = playlist
    }
    
    @IBAction func giveUpButton(_ sender: Any) {
        let giveUpAlert = UIAlertController(title: "Do you want to give up?", message: nil, preferredStyle: .alert)
        let giveUpAction = UIAlertAction(title: "Give up", style: .destructive){ (UIAlertAction) in
            self.navigationController?.popToRootViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Keep playing", style: .cancel)

        giveUpAlert.addAction(giveUpAction)
        giveUpAlert.addAction(cancelAction)
        self.present(giveUpAlert, animated: true)
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

