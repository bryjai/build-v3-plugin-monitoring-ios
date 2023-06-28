//
//  GROWTracesManager.swift
//  Build-V3-Plugin-Monitoring-ios
//
//  Created by Jérôme Morissard on 20/02/2023.
//

import Foundation
import FASDKBuild_ios
import GrowSDK
import WebKit

public class GROWTracesManager: NSObject {
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

extension GROWTracesManager: TracesManager {
    public func performancesMonitoring(sdkEvent: SDKEvent) {
        savedDates[sdkEvent.rawValue] = Date()
        
        if sdkEvent != SDKEvent.sdk_start {
            if let startDate = get(forEvent: SDKEvent.sdk_start.rawValue) {
                let interval = Date().timeIntervalSince(startDate)
                let duration_s = String(format: "%.2fs", interval)
                
                // https://support.bryj.ai/docs/developer-guides/sdk/ios-sdk-integration-guide/
                var event = GrowSDK.Grow.Events.Custom.create(sdkEvent.rawValue)
                event = event.putValue(duration_s, forKey: "duration")
                event.send()
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
            
            if let startDate = get(forEvent: LoadingEvent.native_start.rawValue, webView: webView) {
                let interval = Date().timeIntervalSince(startDate)
                let duration_s = String(format: "%.2fs", interval)
                
                // https://support.bryj.ai/docs/developer-guides/sdk/ios-sdk-integration-guide/
                var event = GrowSDK.Grow.Events.Custom.create(webViewEvent.rawValue)
                event = event.putValue(duration_s, forKey: "duration")
                event = event.putValue("\(index)", forKey: "index")
                if let urlStr = webView.url?.absoluteString {
                    event = event.putValue(urlStr, forKey: "url")
                }
                if let pathStr = webView.url?.path {
                    event = event.putValue(pathStr, forKey: "path")
                }
                event.send()
            }
        }
    }
}
