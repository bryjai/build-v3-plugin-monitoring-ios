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

    public func lifeCycleWebViewWillBeInitialized(sectionViewController: FASectionViewController, configuration: WKWebViewConfiguration) { }
    
    public func lifeCycleWebViewInitialized(sectionViewController: FASectionViewController) {
        let handlers: [String] = [
            PerformancesPluginScriptMessageHandler.performance_DOMContentLoaded,
            PerformancesPluginScriptMessageHandler.performance_DocumentReadyStateComplete,
            PerformancesPluginScriptMessageHandler.performance_DocumentReadyStateIntractive,
            PerformancesPluginScriptMessageHandler.performance_load,
        ]
        
        handlers.forEach { handler in
            self.registerScriptMessageHandler(sectionViewController.userContentController(), name: handler)
        }

        let classBundle = Bundle(for: PerformancesMonitoringPlugin.self)
        if let bundle = Bundle(path: classBundle.bundlePath.appending("/Build-V3-Plugin-Monitoring-ios.bundle")),
            let webView = sectionViewController.webView() {
            webView.addJavascriptFileInjectionIfNeeded(resource: "interface_performances", forMainFrameOnly: true, bundle: bundle)
        }
    }

    private func registerScriptMessageHandler(_ controller: WKUserContentController?, name: String) {
        controller?.removeScriptMessageHandler(forName: name)
        controller?.add(self.scriptMessageHandler, name: name)
    }
}
