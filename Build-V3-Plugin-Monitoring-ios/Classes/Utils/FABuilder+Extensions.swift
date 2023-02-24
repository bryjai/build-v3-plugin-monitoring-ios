//
//  FABuilder+Extensions.swift
//  Build-V3-Plugin-Monitoring-ios
//
//  Created by Jérôme Morissard on 20/02/2023.
//

import FASDKBuild_ios
import Foundation
import WebKit

public extension FABuilder {
    func sectionViewController(webView: WKWebView) -> FASectionViewController? {
        for s in sectionControllers {
            if s.sectionViewController()?.webView() == webView {
                return s.sectionViewController()
            }
        }
        
        return nil
    }
    
    func estimatedTabIndex(webView: WKWebView) -> Int {
        for (idx, s) in FABuilder.shared.sectionControllers.enumerated() {
            if s.sectionViewController()?.webView() == webView {
                return idx
            }
        }
        
        return -1
    }
}

public extension FABuilder {
    func stringifyLoggedInStatus() -> String {
        switch FABuilder.shared.loggedInStatus {
        case .loggedIn:
            return "loggedIn"
        case .loggedOut:
            return "loggedOut"
        case .error:
            return "error"
        default:
            return "unknown"
        }
    }
}

public extension FASectionViewController {
    func userContentController() -> WKUserContentController? {
        return webView()?.configuration.userContentController
    }
    func isPersistantLogin() -> Bool {
        if sectionType() == .webLoginPageSection { return true }
        if sectionType() == .webForceLoginPageSection { return true }
        return false
    }
    func stringifySectionType() -> String {
        switch sectionType() {
        case .webForceLoginPageSection:
            return "webForceLoginPageSection"
        case .webLoginPageSection:
            return "webLoginPageSection"
        case .webGenericSection:
            return "webGenericSection"
        case .webGenericTransientSection:
            return "webGenericTransientSection"
        default:
            return "unknownSection"
        }
    }
}
