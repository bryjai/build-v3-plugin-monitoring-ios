//
//  PerformancesMonitoringPlugin+FAPluginBuilderLifeCycleDelegate.swift
//  Build-V3-Plugin-Monitoring-ios
//
//  Created by Jérôme Morissard on 21/02/2023.
//

import FASDKBuild_ios
import Foundation

extension PerformancesMonitoringPlugin: FAPluginBuilderLifeCycleDelegate {
    public func builderWillStart() {
        saveCurrentDate(forEvent: SDKEvent.sdk_start)
    }
        
    public func builderRemoveSplashView() {
        saveCurrentDate(forEvent: SDKEvent.sdk_remove_splashview)
    }
}
