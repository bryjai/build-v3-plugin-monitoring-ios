# Build-V3-Plugin-Monitoring-ios

Build-V3-Plugin-Monitoring-ios is a plugin capable of monitoring the app performance.

## Metrics

-   **Durations**, to load each webviews:

    -   **native_start**: The native event when the webview starts to load an url
    -   **web_load**: The web event when the webview starts to load the DOM
    -   **web_DOMContentLoaded**: The web event when the webview has downloaded the DOM
    -   **web_DocumentReadyStateInteractive**: The web event when the webview state changes to interactive
    -   **web_DocumentReadyStateComplete**: The web event when the webview state changes to complete
    -   **native_didFinish**: The native event when the webview finished downloading all the resources

-   **Sections**, to identify each webview using an index.

-   **Build events**, some important events in a Build app

    -   **sdk_start**
    -   **sdk_remove_splashview** : when the initial splashscreen is removed
    -   **sdk_all_webviews_are_loaded** : when all the webviews (all sections) are loaded

-   **Traces attributes**:

    -   **url**
    -   **path**
    -   **sectionType**
    -   **sectionIndex**
    -   **loggedInStatus**

## Usage

```Swift
override func getPlugins() -> [FABasePlugin] {
    let debugManager = DebugPrintTracesManager() // log traces in the console
    let firebaseManager = FirebasePerformanceTracesManager() // log traces on Firebase Performance
    let growManager = GROWTracesManager() // log traces as GROW events

    let plugin = PerformancesMonitoringPlugin(tracesManagers: [debugManager, firebaseManager, growManager])
    return [plugin]
}
```

Register additional attributes in the Firebase Performance

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
    func updateTraceAdditional(attributes: [String : String]) -> [String : String] {
        var dict = attributes
        dict["app_configuration"] = "only_the_1st"

        return dict
    }
}
```

## Installation

To install it, simply add the following line to your Podfile:

```ruby
pod 'Build-V3-Plugin-Monitoring-ios/Core', :git => 'git@github.com:bryjai/build-v3-sdk-plugin-monitoring-ios.git'

# Firebase
pod 'Build-V3-Plugin-Monitoring-ios/FirebasePerformance', :git => 'git@github.com:bryjai/build-v3-sdk-plugin-monitoring-ios.git'
pod 'FirebasePerformance'

# GROW
pod 'Build-V3-Plugin-Monitoring-ios/GROW', :git => 'git@github.com:bryjai/build-v3-sdk-plugin-monitoring-ios.git'
```

## Roadmap

[ ] Add Datadog traces support  
[ ] Add more SDK life events

## Author

Jérôme Morissard, jerome.morissard@bryj.ai

## License

Build-V3-Plugin-Monitoring-ios is available under the MIT license. See the LICENSE file for more info.
