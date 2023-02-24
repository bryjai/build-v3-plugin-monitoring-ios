//
//  DebugPrintTracesManager.swift
//  Build-V3-Plugin-Monitoring-ios
//
//  Created by Jérôme Morissard on 20/02/2023.
//

import Foundation
import FASDKBuild_ios
import WebKit

public class DebugPrintTracesManager: NSObject {
    var savedDates = [String: Date?]()

    func get(forEvent: String) -> Date? {
        if let d = savedDates[forEvent] {
            return d
        }
        return nil
    }
    
    func get(forEvent: String, webView: WKWebView) -> Date? {
        let address = "\(Unmanaged.passUnretained(webView).toOpaque())"
        if let d = savedDates["\(address)_\(forEvent)"] {
            return d
        }
        return nil
    }
}

extension DebugPrintTracesManager: TracesManager {
    public func performancesMonitoring(sdkEvent: SDKEvent) {
        savedDates[sdkEvent.rawValue] = Date()
        
        if sdkEvent != SDKEvent.sdk_start {
            if let startDate = get(forEvent: SDKEvent.sdk_start.rawValue) {
                let interval = Date().timeIntervalSince(startDate)
                let duration_s = String(format: "%.2fs", interval)
                debugPrint("🚦 \(sdkEvent) in \(duration_s)")
            }
        }
    }
    
    public func performancesMonitoring(webViewEvent: LoadingEvent, sectionViewController: FASectionViewController) {
        let strEvent = webViewEvent.rawValue
        
        guard let webView = sectionViewController.webView() else {
            return
        }
        
        let address = "\(Unmanaged.passUnretained(webView).toOpaque())"
        savedDates["\(address)_\(strEvent)"] = Date()
        
        if webViewEvent != LoadingEvent.native_start {
            let index = FABuilder.shared.estimatedTabIndex(webView: webView)
            
            if sectionViewController.isPersistantLogin() {
                debugPrint("sectionViewController.isPersistantLogin")
            }
            
            if let startDate = get(forEvent: LoadingEvent.native_start.rawValue, webView: webView) {
                let interval = Date().timeIntervalSince(startDate)
                let duration_s = String(format: "%.2fs", interval)
                debugPrint("🚦 Section:\(index) \(webViewEvent) in \(duration_s) url:\(webView.url!)")
            }
        }
    }
}
