//
//  PerformancesMonitoringPlugin.swift
//  Build-V3-Plugin-Monitoring-ios
//
//  Created by Jérôme Morissard on 05/17/2022.
//  Copyright (c) 2022 Jérôme Morissard. All rights reserved.
//

import FASDKBuild_ios
import Foundation
import WebKit

public protocol PerformancesMonitoringDelegate: NSObject {
    func performancesMonitoring(sdkEvent: SDKEvent)
    func performancesMonitoring(webViewEvent: LoadingEvent, sectionViewController: FASectionViewController)
}

public enum SDKEvent: String {
    case sdk_start
    case stop_sdk_start
    case sdk_remove_splashview
    case sdk_all_webviews_are_loaded
}

public enum LoadingEvent: String {
    /// WebView start event as triggered by the native delegate
    case native_start
    
    /// Website begins loading
    case web_load
    
    /// Web page html hasa loaded
    case web_DOMContentLoaded
    
    /// Web page and all resources has finished loading
    case web_DocumentReadyStateComplete
    
    /// Web page has finished loading but resources are still loading
    case web_DocumentReadyStateIntractive
    
    /// WebView didFinish event as triggered by the native delegate
    case native_didFinish
}

public protocol TracesManager: PerformancesMonitoringDelegate {}

public class PerformancesMonitoringPlugin: FABasePlugin {
    let scriptMessageHandler = PerformancesPluginScriptMessageHandler()
    var tracesManagers = [TracesManager]()
    var allWebviewsAreLoadedTriggerOnce = false
    
    public init(tracesManagers: [TracesManager]) {
        super.init()
        
        /// Listen SDK life events
        self.builderLifeCycleDelegate = self
        
        /// Listen the Section life events
        self.sectionLifeCycleDelegate = self
        
        /// Listen the Section web navigation events
        self.sectionWebViewNavigationDelegate = self
        scriptMessageHandler.plugin = self
        self.tracesManagers = tracesManagers
    }
    
    func saveCurrentDate(forEvent: SDKEvent) {
        if forEvent == .sdk_all_webviews_are_loaded {
            allWebviewsAreLoadedTriggerOnce = true
        }
        
        for m in tracesManagers {
            m.performancesMonitoring(sdkEvent: forEvent)
        }
    }
        
    func saveCurrentDate(forEvent: LoadingEvent, sectionViewController: FASectionViewController) {
        for m in tracesManagers {
            m.performancesMonitoring(webViewEvent: forEvent, sectionViewController: sectionViewController)
        }
    }
}
