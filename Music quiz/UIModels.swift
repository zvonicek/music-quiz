//
//  UIModels.swift
//  Music quiz
//
//  Created by Patrik Potoček on 25.9.18.
//  Copyright © 2018 The Funtasty. All rights reserved.
//

import UIKit

struct PlaylistViewModel {
    let image: URL
    let title, bestScore: String

    init(playlist: Playlist) {
        self.image = playlist.coverUrl!
        self.title = playlist.name
        self.bestScore = "90"
    }
}
