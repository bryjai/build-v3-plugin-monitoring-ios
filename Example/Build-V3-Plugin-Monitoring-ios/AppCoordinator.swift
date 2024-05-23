//
//  AppCoordinator.swift
//  Build-V3-Plugin-Monitoring-ios
//
//  Created by Pedro Fernandes on 17/05/2024.
//  Copyright (c) 2024 Bryj.ai. All rights reserved.
//

import Build_V3_Plugin_Monitoring_ios
import FASDKBuild_ios
import Foundation
import WebKit

// MARK: - AppCoordinator

class AppCoordinator: FABaseAppCoordinator {
    override func getConfigurationName() -> String? {
        return "configuration"
    }

    override func getPlugins() -> [FABasePlugin] {
        var plugins = [FABasePlugin]()

        let firebaseManager = FirebasePerformanceTracesManager()
        firebaseManager.delegate = self

        plugins.append(PerformancesMonitoringPlugin(tracesManagers: [firebaseManager, DebugPrintTracesManager()]))
        return plugins
    }
}

// MARK: FirebasePerformanceDelegate

extension AppCoordinator: FirebasePerformanceDelegate {
    func updateTraceAdditional(attributes: [String: String]) -> [String: String] {
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
