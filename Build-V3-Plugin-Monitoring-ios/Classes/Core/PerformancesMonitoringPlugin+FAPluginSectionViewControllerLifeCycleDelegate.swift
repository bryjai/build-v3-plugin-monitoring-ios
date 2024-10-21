//
//  PerformancesMonitoringPlugin+FAPluginSectionViewControllerLifeCycleDelegate.swift
//  Build-V3-Plugin-Monitoring-ios
//
//  Created by Jérôme Morissard on 21/02/2023.
//

import FASDKBuild_ios
import Foundation
import WebKit

extension PerformancesMonitoringPlugin: FAPluginSectionViewControllerLifeCycleDelegate {
    public func lifeCycleWebViewWillBeInitialized(sectionViewController: FASectionViewController, configuration: WKWebViewConfiguration) {}
    
    public func lifeCycleWebViewInitialized(sectionViewController: FASectionViewController) {
        let handlers: [String] = [
            PerformancesPluginScriptMessageHandler.performance_DOMContentLoaded,
            PerformancesPluginScriptMessageHandler.performance_DocumentReadyStateComplete,
            PerformancesPluginScriptMessageHandler.performance_DocumentReadyStateIntractive,
            PerformancesPluginScriptMessageHandler.performance_load,
        ]
        for handler in handlers {
            sectionViewController.userContentController()?.removeScriptMessageHandler(forName: handler)
            sectionViewController.userContentController()?.add(scriptMessageHandler, name: handler)
        }
        let classBundle = Bundle(for: PerformancesMonitoringPlugin.self)
        if let bundle = Bundle(path: classBundle.bundlePath.appending("/Build-V3-Plugin-Monitoring-ios.bundle")) {
            sectionViewController.webView()!.addJavascriptFileInjectionIfNeeded(resource: "interface_performances", forMainFrameOnly: true, bundle: bundle)
        }
    }
}
