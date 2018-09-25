//
//  ChoosePlaylistViewController.swift
//  Music quiz
//
//  Created by Patrik Potoček on 25.9.18.
//  Copyright © 2018 The Funtasty. All rights reserved.
//

import UIKit

class ChoosePlaylistViewController: UIViewController {

    @IBOutlet weak var playlistsCollection: UICollectionView!

    let playlistIds = ["37i9dQZF1DWWGFQLoP9qlv", "37i9dQZF1DXcBWIGoYBM5M", "37i9dQZF1DX186v583rmzp", "37i9dQZF1DXaXB8fQg7xif", "37i9dQZF1DX2ENAPP1Tyed","37i9dQZF1DX6xOPeSOGone"]
    
    var playlistsViewModels: [PlaylistViewModel] = []
    var playlists: [Playlist] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            SpotifyAPI.sharedInstance.getPlaylists(playlistIds: self.playlistIds) { playlists in
                self.playlists = playlists
                self.playlistsViewModels = playlists.map(PlaylistViewModel.init)
                DispatchQueue.main.async {
                    self.playlistsCollection.reloadData()
                }
            }
        }

        playlistsCollection.delegate = self
        playlistsCollection.dataSource = self
        playlistsCollection.register(UINib(nibName: "PlaylistCell", bundle: .main), forCellWithReuseIdentifier: "playlistCellID")

        let cellWidth = (UIScreen.main.bounds.size.width - 50) / 2
        let flowLayout = playlistsCollection.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        flowLayout.minimumLineSpacing = 20

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let sender = sender as! (Playlist, PlaylistViewModel)
        (segue.destination as! PlaylistViewController).playlist = sender.0
        (segue.destination as! PlaylistViewController).playlistViewModel = sender.1

    }

}

extension ChoosePlaylistViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlistsViewModels.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let playlistCell = collectionView.dequeueReusableCell(withReuseIdentifier: "playlistCellID", for: indexPath) as! PlaylistCell
        
        playlistCell.configure(with: playlistsViewModels[indexPath.row].image)
        return playlistCell
    }
}

extension ChoosePlaylistViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "pushToPlaylistDetail", sender: (playlists[indexPath.row], playlistsViewModels[indexPath.row]))
    }
}



