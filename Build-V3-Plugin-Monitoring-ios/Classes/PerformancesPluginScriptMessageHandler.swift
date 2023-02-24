//
//  PerformancesPluginScriptMessageHandler.swift
//  Build-V3-Plugin-Monitoring-ios
//
//  Created by Jérôme Morissard on 21/02/2023.
//

import FASDKBuild_ios
import Foundation
import WebKit

class PerformancesPluginScriptMessageHandler: NSObject, WKScriptMessageHandler {
    static let performance_DOMContentLoaded             = "bryj_performance_domcontentloaded"
    static let performance_DocumentReadyStateComplete   = "bryj_performance_readystatechange_complete"
    static let performance_DocumentReadyStateIntractive = "bryj_performance_readystatechange_interactive"
    static let performance_load                         = "bryj_performance_load"
    
    weak var plugin: PerformancesMonitoringPlugin?
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == PerformancesPluginScriptMessageHandler.performance_DOMContentLoaded {
            if let wb = message.webView, let sectionVC = FABuilder.shared.sectionViewController(webView: wb) {
                plugin?.saveCurrentDate(forEvent: LoadingEvent.web_DOMContentLoaded,
                                        sectionViewController: sectionVC)
            }
        } else if message.name == PerformancesPluginScriptMessageHandler.performance_DocumentReadyStateComplete {
            if let wb = message.webView, let sectionVC = FABuilder.shared.sectionViewController(webView: wb) {
                plugin?.saveCurrentDate(forEvent: LoadingEvent.web_DocumentReadyStateComplete,
                                        sectionViewController: sectionVC)
            }
        } else if message.name == PerformancesPluginScriptMessageHandler.performance_DocumentReadyStateIntractive {
            if let wb = message.webView, let sectionVC = FABuilder.shared.sectionViewController(webView: wb) {
                plugin?.saveCurrentDate(forEvent: LoadingEvent.web_DocumentReadyStateIntractive,
                                        sectionViewController: sectionVC)
            }
        } else if message.name == PerformancesPluginScriptMessageHandler.performance_load {
            if let wb = message.webView, let sectionVC = FABuilder.shared.sectionViewController(webView: wb) {
                plugin?.saveCurrentDate(forEvent: LoadingEvent.web_load,
                                        sectionViewController: sectionVC)
            }
        }
    }
}
