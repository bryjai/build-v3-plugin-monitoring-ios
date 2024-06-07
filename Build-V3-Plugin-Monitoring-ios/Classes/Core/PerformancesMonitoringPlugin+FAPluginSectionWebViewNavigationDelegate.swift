//
//  PerformancesMonitoringPlugin+FAPluginSectionWebViewNavigationDelegate.swift
//  Build-V3-Plugin-Monitoring-ios
//
//  Created by Jérôme Morissard on 21/02/2023.
//

import FASDKBuild_ios
import Foundation
import WebKit

extension PerformancesMonitoringPlugin: FAPluginSectionWebViewNavigationDelegate {
    public func sectionViewControllerDidStart(navigation: WKNavigation!, sectionViewController: FASectionViewController) {
        saveCurrentDate(forEvent: LoadingEvent.native_start, sectionViewController: sectionViewController)
    }
    
    public func sectionViewControllerDidFinish(navigation: WKNavigation!, sectionViewController: FASectionViewController) {
        saveCurrentDate(forEvent: LoadingEvent.native_didFinish, sectionViewController: sectionViewController)
        
        if allWebviewsAreLoadedTriggerOnce == true  {
            return
        }
        
        // check if all webViews are loaded ?
        var allWebViewsAreLoaded = true
        for vc in FABuilder.shared.sectionControllers where vc.sectionViewController()?.isNativeSection() == false {
            if let estimatedProgress = vc.sectionViewController()?.webView()?.estimatedProgress {
                if estimatedProgress < 1.0 {
                    allWebViewsAreLoaded = false
                }
            } else {
                allWebViewsAreLoaded = false
            }
        }
        
        if allWebViewsAreLoaded {
            saveCurrentDate(forEvent: SDKEvent.sdk_all_webviews_are_loaded)
        }
    }
    
    public func sectionViewControllerDecidePolicyFor(navigationAction: WKNavigationAction, sectionViewController: FASectionViewController) -> (actionPolicy: WKNavigationActionPolicy, urlToLoad: URL?) {
        return (.allow, nil)
    }
    
    public func sectionViewControllerDecidePolicyFor(navigationResponse: WKNavigationResponse, sectionViewController: FASectionViewController) -> WKNavigationResponsePolicy {
        return .allow
    }
    
    public func sectionViewControllerDidReceive(challenge: URLAuthenticationChallenge, sectionViewController: FASectionViewController) -> URLSession.AuthChallengeDisposition {
        return .useCredential
    }
}
