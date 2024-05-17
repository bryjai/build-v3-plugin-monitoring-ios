//
//  AppCoordinator.swift
//  FASDKBuild-Plugin-Optimizers-ios
//
//  Created by Jérôme Morissard on 05/17/2022.
//  Copyright (c) 2022 Jérôme Morissard. All rights reserved.
//

import Build_V3_Plugin_Monitoring_ios
import FASDKBuild_ios
import Foundation
import WebKit

class AppCoordinator: FABaseAppCoordinator {
    override func getConfigurationName() -> String? {
        return "configuration"
    }

    override func getPlugins() -> [FABasePlugin] {
        var plugins = [FABasePlugin]()

        let firebaseManager = FirebasePerformanceTracesManager()
        firebaseManager.delegate = self

        let debugManager = DebugPrintTracesManager()

        let monitoringPlugin = PerformancesMonitoringPlugin(tracesManagers: [firebaseManager, debugManager])

        plugins.append(monitoringPlugin)
        return plugins
    }
}

extension AppCoordinator: FirebasePerformanceDelegate {
    func updateTraceAdditional(attributes: [String : String]) -> [String : String] {
        return attributes
    }
    
    func performanceTraceNameForSDKEvent(for event: Build_V3_Plugin_Monitoring_ios.SDKEvent) -> String {
        return "SplashRemoved"
    }
    
    func performanceTraceNameForWebViewDidFinish(webViewAtIndex: Int) -> String {
        return "WebViewDidFinish"
    }
    
    func performanceTraceNameForWebViewDOMContentLoaded(webViewAtIndex: Int) -> String {
        return "WebViewDOMContentLoaded("
    }
}
