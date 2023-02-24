# Build-V3-Plugin-Monitoring-ios

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

FASDKBuild-Plugin-Monitor-Performances-ios is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Build-V3-Plugin-Monitoring-ios', :git => 'git@github.com:bryjai/build-v3-sdk-plugin-monitoring-ios.git'
```

## Firebase integration demo 

The Plugin can be connected to Firebase Performance project.
For now, this code is developed in the Client App.

Sample of Firebase Performance implementation by implementing the protocol PerformancesMonitoringDelegate
This sample is available in the demo project of that plugin. 

```Swift
// Register the right Plugin (PerformancesMonitoringPlugin)
    override func getPlugins() -> [FABasePlugin] {
        let firebaseManager = FirebasePerformanceTracesManager() // to log traces on Firebase Performances
        let debugManager = DebugPrintTracesManager() // to log traces in the console
        let plugin = PerformancesMonitoringPlugin(tracesManagers: [firebaseManager, debugManager])
        return [plugin]
    }
```

Register additional attributes to the Firebase Traces
```Swift
class AppCoordinator: FABaseAppCoordinator {    
    override func getConfigurationName() -> String? {
        return "configuration"
    }
    
    override func getPlugins() -> [FABasePlugin] {
        let firebaseManager = FirebasePerformanceTracesManager()
        firebaseManager.delegate = self
        let plugin = PerformancesMonitoringPlugin(tracesManagers: [firebaseManager])
        return [plugin]
    }
}

extension AppCoordinator: FirebasePerformanceDelegate {
    // Additional attributes to track
    func updateTraceAdditional(attributes: [String : String]) -> [String : String] {
        var dict = attributes
        dict["app_configuration"] = "only_the_1st" //  loading_all_serialized // only_the_1st
        return dict
    }
}

```

## RoadMap 
[ ] Add Datadog traces support 
[ ] Add more SDK life Events 

## Author

Jérôme Morissard, jerome.morissard@followanalytics.com

## License

FASDKBuild-Plugin-Monitor-Performances-ios is available under the MIT license. See the LICENSE file for more info.
