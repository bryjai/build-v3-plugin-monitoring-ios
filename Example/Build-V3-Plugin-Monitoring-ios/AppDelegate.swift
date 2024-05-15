//
//  AppDelegate.swift
//  Build-V3-Plugin-Monitoring-ios
//
//  Created by Jérôme Morissard on 06/28/2023.
//  Copyright (c) 2023 Jérôme Morissard. All rights reserved.
//

import FASDKBuild_ios
import UIKit
import FirebaseCore

@UIApplicationMain
class AppDelegate: FABaseAppDelegate {
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // setup firebase to use monitoring plugin
        FirebaseApp.configure()
        appCoordinator = AppCoordinator(window: self.window!)
        appCoordinator.start()
        window?.makeKeyAndVisible()
        return true
    }
}
