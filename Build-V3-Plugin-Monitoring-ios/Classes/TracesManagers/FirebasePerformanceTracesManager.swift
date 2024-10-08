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
    func performanceTraceNameForSDKEvent(for event: SDKEvent) -> String
    func performanceTraceNameForWebViewDidFinish(webViewAtIndex: Int) -> String
    func performanceTraceNameForWebViewDOMContentLoaded(webViewAtIndex: Int) -> String
    func performanceTraceNameForWebDocumentReadyStateComplete(webViewAtIndex: Int) -> String
    func performanceTraceNameForWebDocumentReadyStateIntractive(webViewAtIndex: Int) -> String
    func performanceTraceNameForWebLoad(webViewAtIndex: Int) -> String
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

    public func start(traceName: String) {
        let trace = Performance.startTrace(name: traceName)
        startedTraces[traceName] = trace
    }

    public func end(traceName: String) {
        if let trace = startedTraces[traceName] {
            trace.stop()
            startedTraces[traceName] = nil
        }
    }
}

extension FirebasePerformanceTracesManager: TracesManager {
    public func performancesMonitoring(sdkEvent: SDKEvent) {
        if sdkEvent == .sdk_start {
            let sdkStart = delegate?.performanceTraceNameForSDKEvent(for: .sdk_start) ?? performanceTraceNameForSDKEvent(for: .sdk_start)
            let sdkStartTrace = Performance.startTrace(name: sdkStart)
            startedTraces[sdkStart] = sdkStartTrace
            
            let sdkRemoveSplashviewTraceName =
                delegate?.performanceTraceNameForSDKEvent(for: .sdk_remove_splashview) ?? performanceTraceNameForSDKEvent(for: .sdk_remove_splashview)
            let sdkRemoveSplashviewTrace = Performance.startTrace(name: sdkRemoveSplashviewTraceName)
            startedTraces[SDKEvent.sdk_remove_splashview.rawValue] = sdkRemoveSplashviewTrace

            let sdkAllWebviewsAreLoadedTraceName =
                delegate?.performanceTraceNameForSDKEvent(for: .sdk_all_webviews_are_loaded) ?? performanceTraceNameForSDKEvent(for: .sdk_all_webviews_are_loaded)
            let sdkAllWebviewsAreLoadedTrace = Performance.startTrace(name: sdkAllWebviewsAreLoadedTraceName)
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
        
        if sdkEvent == .stop_sdk_start, let trace = startedTraces[SDKEvent.sdk_start.rawValue] {
            setAttributes(toTrace: trace, delegate: self.delegate)
            trace.stop()
            startedTraces[SDKEvent.sdk_start.rawValue] = nil
        }
    }
    
    public func performancesMonitoring(webViewEvent: LoadingEvent, sectionViewController: FASectionViewController) {
        let index = sectionViewController.estimatedTabIndex()

        if webViewEvent == .native_start {
            let didFinishTraceName =
                delegate?.performanceTraceNameForWebViewDidFinish(webViewAtIndex: index) ?? performanceTraceNameForWebViewDidFinish(webViewAtIndex: index)
            let webViewLoadingDidFinishTrace = Performance.startTrace(name: didFinishTraceName)
            startedTraces[didFinishTraceName] = webViewLoadingDidFinishTrace
            
            let DOMContentLoadedTraceName =
                delegate?.performanceTraceNameForWebViewDOMContentLoaded(webViewAtIndex: index) ?? performanceTraceNameForWebViewDOMContentLoaded(webViewAtIndex: index)
            let DOMContentLoadedTrace = Performance.startTrace(name: DOMContentLoadedTraceName)
            startedTraces[DOMContentLoadedTraceName] = DOMContentLoadedTrace
            
            let webLoadTraceName = delegate?.performanceTraceNameForWebLoad(webViewAtIndex: index) ?? performanceTraceNameForWebLoad(webViewAtIndex: index)
            let webLoadTrace = Performance.startTrace(name: webLoadTraceName)
            startedTraces[webLoadTraceName] = webLoadTrace
            
            let webDocumentReadyStateIntractiveTraceName = delegate?.performanceTraceNameForWebDocumentReadyStateIntractive(webViewAtIndex: index) ?? performanceTraceNameForWebDocumentReadyStateIntractive(webViewAtIndex: index)
            let webDocumentReadyStateIntractiveTrace = Performance.startTrace(name: webDocumentReadyStateIntractiveTraceName)
            startedTraces[webDocumentReadyStateIntractiveTraceName] = webDocumentReadyStateIntractiveTrace
            
            let webDocumentReadyStateCompleteTraceName = delegate?.performanceTraceNameForWebDocumentReadyStateComplete(webViewAtIndex: index) ?? performanceTraceNameForWebDocumentReadyStateComplete(webViewAtIndex: index)
            let webDocumentReadyStateCompleteTrace = Performance.startTrace(name: webDocumentReadyStateCompleteTraceName)
            startedTraces[webDocumentReadyStateCompleteTraceName] = webDocumentReadyStateCompleteTrace
        }
        
        if webViewEvent == .native_didFinish {
            let traceName =
                delegate?.performanceTraceNameForWebViewDidFinish(webViewAtIndex: index) ?? performanceTraceNameForWebViewDidFinish(webViewAtIndex: index)
            if let trace = startedTraces[traceName] {
                sectionViewController.setAttributes(toTrace: trace, delegate: self.delegate)
                trace.stop()
                startedTraces[traceName] = nil
            }
        }
        
        if webViewEvent == .web_DOMContentLoaded {
            let traceName =
                delegate?.performanceTraceNameForWebViewDOMContentLoaded(webViewAtIndex: index) ?? performanceTraceNameForWebViewDOMContentLoaded(webViewAtIndex: index)
            if let trace = startedTraces[traceName] {
                sectionViewController.setAttributes(toTrace: trace, delegate: self.delegate)
                trace.stop()
                startedTraces[traceName] = nil
            }
        }
        
        if webViewEvent == .web_load {
            let traceName = delegate?.performanceTraceNameForWebLoad(webViewAtIndex: index) ?? performanceTraceNameForWebLoad(webViewAtIndex: index)
            if let trace = startedTraces[traceName] {
                sectionViewController.setAttributes(toTrace: trace, delegate: self.delegate)
                trace.stop()
                startedTraces[traceName] = nil
            }
        }
        
        if webViewEvent == .web_DocumentReadyStateIntractive{
            let traceName = delegate?.performanceTraceNameForWebDocumentReadyStateIntractive(webViewAtIndex: index) ?? performanceTraceNameForWebDocumentReadyStateIntractive(webViewAtIndex: index)
            if let trace = startedTraces[traceName] {
                sectionViewController.setAttributes(toTrace: trace, delegate: self.delegate)
                trace.stop()
                startedTraces[traceName] = nil
            }
        }
        
        if webViewEvent == .web_DocumentReadyStateComplete {
            let traceName = delegate?.performanceTraceNameForWebDocumentReadyStateComplete(webViewAtIndex: index) ?? performanceTraceNameForWebDocumentReadyStateComplete(webViewAtIndex: index)
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
}

extension FirebasePerformanceTracesManager: FirebasePerformanceDelegate {
    public func updateTraceAdditional(attributes: [String : String]) -> [String : String] {
        return attributes
    }

    public func performanceTraceNameForSDKEvent(for event: SDKEvent) -> String {
        return event.rawValue
    }

    public func performanceTraceNameForWebViewDidFinish(webViewAtIndex: Int) -> String {
        return "webView_\(webViewAtIndex)_didFinish"
    }

    public func performanceTraceNameForWebViewDOMContentLoaded(webViewAtIndex: Int) -> String {
        return "webView_\(webViewAtIndex)_DOMContentLoaded"
    }
    
    public func performanceTraceNameForWebDocumentReadyStateComplete(webViewAtIndex: Int) -> String {
        return "webView_\(webViewAtIndex)_DocumentReadyStateComplete"
    }
    
    public func performanceTraceNameForWebDocumentReadyStateIntractive(webViewAtIndex: Int) -> String {
        return "webView_\(webViewAtIndex)_DocumentReadyStateIntractive"
    }
    
    public func performanceTraceNameForWebLoad(webViewAtIndex: Int) -> String {
        return "webView_\(webViewAtIndex)_load"
    }
}
