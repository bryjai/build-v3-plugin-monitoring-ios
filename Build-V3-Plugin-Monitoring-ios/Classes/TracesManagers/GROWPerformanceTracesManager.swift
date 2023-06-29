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

public class PluginMonitorTrace {
    var traceName: String
    var event: String
    var startDate = Date()
    var attributes = [String:String]()
    
    init(traceName: String, event: String) {
        self.traceName = traceName
        self.event = event
    }
}

public class GROWTracesManager: NSObject {
    public weak var delegate: MonitorPluginDelegate?
    var savedTraces = [String: PluginMonitorTrace?]()
    
    func start(traceName: String, event: String) {
        let t = PluginMonitorTrace(traceName: traceName, event: event)
        savedTraces[traceName] = t
    }
    
    func end(traceName: String) -> PluginMonitorTrace? {
        if let t = savedTraces[traceName] {
            savedTraces.removeValue(forKey: traceName)
            
            let interval = Date().timeIntervalSince(t!.startDate)
            let duration_s = String(format: "%.2f", interval)
            t!.attributes["duration"] = duration_s
            return t
        }
        
        return nil
    }
    
    func send(trace: PluginMonitorTrace) {
        if let d = delegate {
            d.enrich(trace: trace)
        }
        
        // https://support.bryj.ai/docs/developer-guides/sdk/ios-sdk-integration-guide/
        var event = GrowSDK.Grow.Events.Custom.create(trace.event)
        for key in trace.attributes.keys {
            if let v = trace.attributes[key] {
                event = event.putValue(v, forKey: key)
            }
        }
        event.send()
    }
}

extension GROWTracesManager: TracesManager {
    public func performancesMonitoring(sdkEvent: SDKEvent) {
        var trace: PluginMonitorTrace?
        
        switch(sdkEvent){
        case .sdk_start:
            start(traceName: SDKEvent.sdk_remove_splashview.rawValue, event: "sdk_remove_splashview")
            start(traceName: SDKEvent.sdk_all_webviews_are_loaded.rawValue, event: "sdk_all_webviews_are_loaded")
            
        case .sdk_remove_splashview:
            trace = end(traceName: SDKEvent.sdk_remove_splashview.rawValue)

        case .sdk_all_webviews_are_loaded:
            trace = end(traceName: SDKEvent.sdk_all_webviews_are_loaded.rawValue)
        }
        
        if let t = trace {
            enrich(trace: t)
            send(trace: t)
        }
    }
    
    public func performancesMonitoring(webViewEvent: LoadingEvent, sectionViewController: FASectionViewController) {
        guard let webView = sectionViewController.webView() else {
            return
        }
        
        let address = "\(Unmanaged.passUnretained(webView).toOpaque())"
        let strEvent = webViewEvent.rawValue
        
        var trace: PluginMonitorTrace?
        switch(webViewEvent){
        case .native_start:
            start(traceName: "\(address)_\(LoadingEvent.web_load.rawValue)",
                  event: "web_load")
            
            start(traceName: "\(address)_\(LoadingEvent.web_DOMContentLoaded.rawValue)",
                  event: "web_DOMContentLoaded")
            
            start(traceName: "\(address)_\(LoadingEvent.web_DocumentReadyStateIntractive.rawValue)",
                  event: "web_DocumentReadyStateIntractive")
            
            start(traceName: "\(address)_\(LoadingEvent.web_DocumentReadyStateComplete.rawValue)",
                  event: "web_DocumentReadyStateComplete")
            
            start(traceName: "\(address)_\(LoadingEvent.native_didFinish.rawValue)",
                  event: "native_didFinish")

        case .web_load:
            trace = end(traceName: "\(address)_\(LoadingEvent.web_load.rawValue)")
            
        case .web_DOMContentLoaded:
            trace = end(traceName: "\(address)_\(LoadingEvent.web_DOMContentLoaded.rawValue)")

        case .web_DocumentReadyStateIntractive:
            trace = end(traceName: "\(address)_\(LoadingEvent.web_DocumentReadyStateIntractive.rawValue)")

        case .web_DocumentReadyStateComplete:
            trace = end(traceName: "\(address)_\(LoadingEvent.web_DocumentReadyStateComplete.rawValue)")

        case .native_didFinish:
            trace = end(traceName: "\(address)_\(LoadingEvent.native_didFinish.rawValue)")
        }

        if let t = trace {
            enrich(trace: t)
            enrich(trace: t, usingWebView: webView)
            send(trace: t)
        }
    }
}

extension GROWTracesManager {
    func enrich(trace: PluginMonitorTrace) {
        trace.attributes["loginState"] = FABuilder.shared.stringifyLoggedInStatus()
    }
    
    func enrich(trace: PluginMonitorTrace, usingWebView: WKWebView) {
        let index = FABuilder.shared.estimatedTabIndex(webView: usingWebView)
        trace.attributes["index"] = "\(index)"
        if let urlStr = usingWebView.url?.absoluteString {
            trace.attributes["url"] = urlStr
        }
        if let pathStr = usingWebView.url?.path {
            trace.attributes["path"] = pathStr
        }
    }
}

public protocol MonitorPluginDelegate: NSObject {
    func enrich(trace: PluginMonitorTrace)
}
