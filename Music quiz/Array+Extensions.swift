//
//  Array+Extensions.swift
//  Music quiz
//
//  Created by Petr Zvoníček on 25.09.18.
//  Copyright © 2018 The Funtasty. All rights reserved.
//

import Foundation

extension Array {
    mutating func shuffle() {
        for _ in 0..<((count>0) ? (count-1) : 0) {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}
