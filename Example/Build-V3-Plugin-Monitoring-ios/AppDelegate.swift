//
//  AppDelegate.swift
//  Build-V3-Plugin-Monitoring-ios
//
//  Created by Pedro Fernandes on 17/05/2024.
//  Copyright (c) 2024 Bryj.ai. All rights reserved.
//

import FASDKBuild_ios

import FirebaseCore
import UIKit

@UIApplicationMain
class AppDelegate: FABaseAppDelegate {
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        appCoordinator = AppCoordinator(window: self.window!)
        appCoordinator.start()

        window?.makeKeyAndVisible()
        return true
    }
}
