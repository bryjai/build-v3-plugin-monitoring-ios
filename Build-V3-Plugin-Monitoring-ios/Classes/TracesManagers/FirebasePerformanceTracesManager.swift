//
//  FirebasePerformanceTracesManager.swift
//  Build-V3-Plugin-Monitoring-ios
//
//  Created by Jérôme Morissard on 20/02/2023.
//

import FASDKBuild_ios
import FirebasePerformance
import Foundation
import WebKit

public protocol FirebasePerformanceDelegate {
    func updateTraceAdditional(attributes: [String : String]) -> [String : String]
}

public class FirebasePerformanceTracesManager: NSObject {
    var startedTraces = [String: Trace]()
    public var delegate: FirebasePerformanceDelegate? = nil
}

extension FASectionViewController {
    func setAttributes(toTrace: Trace, delegate: FirebasePerformanceDelegate?) {
        var attributes = [String:String]()
        
        if let str = webView()?.url?.absoluteString {
            attributes["url"] = str
        }
        
        if let path = webView()?.url?.path {
            attributes["path"] = path
        }
        
        // sectionType
        attributes["sectionType"] = stringifySectionType()

        
        // sectionIndex
        var index = -1
        if let wb = webView() {
            index = FABuilder.shared.estimatedTabIndex(webView: wb)
        }
        attributes["sectionIndex"] = "\(index)"
        
        // userIsLoggedIn
        attributes["loggedInStatus"] = FABuilder.shared.stringifyLoggedInStatus()
            
        if let d = delegate {
            attributes = d.updateTraceAdditional(attributes: attributes)
        }
        
        for k in attributes.keys {
            if let v = attributes[k] {
                toTrace.setValue(v, forAttribute: k)
            }
        }
    }
}

extension FirebasePerformanceTracesManager {
    func setAttributes(toTrace: Trace, delegate: FirebasePerformanceDelegate?) {
        var attributes = [String:String]()
        
        // userIsLoggedIn
        attributes["loggedInStatus"] = FABuilder.shared.stringifyLoggedInStatus()
            
        if let d = delegate {
            attributes = d.updateTraceAdditional(attributes: attributes)
        }
        
        for k in attributes.keys {
            if let v = attributes[k] {
                toTrace.setValue(v, forAttribute: k)
            }
        }
    }

    func start(traceName: String) {
        let trace = Performance.startTrace(name: traceName)
        startedTraces[traceName] = trace
    }

    func end(traceName: String) {
        if let trace = startedTraces[traceName] {
            trace.stop()
            startedTraces[traceName] = nil
        }
    }
}

extension FirebasePerformanceTracesManager: TracesManager {
    public func performancesMonitoring(sdkEvent: SDKEvent) {
        if sdkEvent == .sdk_start {
            let sdkRemoveSplashviewTrace = Performance.startTrace(name: SDKEvent.sdk_remove_splashview.rawValue)
            startedTraces[SDKEvent.sdk_remove_splashview.rawValue] = sdkRemoveSplashviewTrace
            let sdkAllWebviewsAreLoadedTrace = Performance.startTrace(name: SDKEvent.sdk_all_webviews_are_loaded.rawValue)
            startedTraces[SDKEvent.sdk_all_webviews_are_loaded.rawValue] = sdkAllWebviewsAreLoadedTrace
        }
        
        if sdkEvent == .sdk_remove_splashview, let trace = startedTraces[SDKEvent.sdk_remove_splashview.rawValue] {
            setAttributes(toTrace: trace, delegate: self.delegate)
            trace.stop()
            startedTraces[SDKEvent.sdk_remove_splashview.rawValue] = nil
        }

        if sdkEvent == .sdk_all_webviews_are_loaded, let trace = startedTraces[SDKEvent.sdk_all_webviews_are_loaded.rawValue] {
            setAttributes(toTrace: trace, delegate: self.delegate)
            trace.stop()
            startedTraces[SDKEvent.sdk_all_webviews_are_loaded.rawValue] = nil
        }
    }
    
    public func performancesMonitoring(webViewEvent: LoadingEvent, sectionViewController: FASectionViewController) {
        if webViewEvent == .native_start {
            let didFinishTraceName = sectionViewController.performance_didFinishTraceName()
            let webViewLoadingDidFinishTrace = Performance.startTrace(name: didFinishTraceName)
            startedTraces[didFinishTraceName] = webViewLoadingDidFinishTrace
            
            let DOMContentLoadedTraceName = sectionViewController.performance_DOMContentLoadedTraceName()
            let DOMContentLoadedTrace = Performance.startTrace(name: DOMContentLoadedTraceName)
            startedTraces[DOMContentLoadedTraceName] = DOMContentLoadedTrace
        }
        
        if webViewEvent == .native_didFinish {
            let traceName = sectionViewController.performance_didFinishTraceName()
            if let trace = startedTraces[traceName] {
                sectionViewController.setAttributes(toTrace: trace, delegate: self.delegate)
                trace.stop()
                startedTraces[traceName] = nil
            }
        }
        
        if webViewEvent == .web_DOMContentLoaded {
            let traceName = sectionViewController.performance_DOMContentLoadedTraceName()
            if let trace = startedTraces[traceName] {
                sectionViewController.setAttributes(toTrace: trace, delegate: self.delegate)
                trace.stop()
                startedTraces[traceName] = nil
            }
        }
    }
}

extension FASectionViewController {
    func estimatedTabIndex() -> Int {
        var index = -1
        if let wv = webView() {
            index = FABuilder.shared.estimatedTabIndex(webView: wv)
        }
        return index
    }
    
    func performance_didFinishTraceName() -> String {
        let index = estimatedTabIndex()
        return "webView_\(index)_didFinish"
    }
    
    func performance_DOMContentLoadedTraceName() -> String {
        let index = estimatedTabIndex()
        return "webView_\(index)_DOMContentLoaded"
    }
}
