//
//  AppDelegate.swift
//  Music quiz
//
//  Created by Patrik Potoček on 25.9.18.
//  Copyright © 2018 The Funtasty. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // Enable Background
        UIApplication.shared.beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()

        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("error..")
        }

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        SpotifyAPI.sharedInstance.authorize()
    }
}
