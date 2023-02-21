//
//  TealiumHelper.swift
//  TealiumBranchExample
//
//  Created by Tyler Rister on 10/18/21.
//

import Foundation
import TealiumSwift
import TealiumBranch

enum TealiumConfiguration {
    static let account = "tealiummobile"
    static let profile = "tyler-test"
    static let environment = "dev"
}

class TealiumHelper {
    static let shared = TealiumHelper()
    
    let config = TealiumConfig(account: TealiumConfiguration.account, profile: TealiumConfiguration.profile, environment: TealiumConfiguration.environment)
    
    var tealium: Tealium?
    
    let branchRemoteCommand = BranchRemoteCommand(type: .local(file: "branch", bundle: Bundle.main))
    
    private init() {
        config.shouldUseRemotePublishSettings = false
        config.batchingEnabled = false
        config.remoteAPIEnabled = true
        config.logLevel = .info
        config.collectors = [Collectors.Connectivity, Collectors.Lifecycle]
        config.dispatchers = [//Dispatchers.TagManagement,
                              Dispatchers.RemoteCommands]
        
        config.addRemoteCommand(branchRemoteCommand)
        
        tealium = Tealium(config: config)
    }
    
    class func start() {
        _ = TealiumHelper.shared
    }

    class func trackView(title: String, data: [String: Any]?) {
        let tealiumView = TealiumView(title, dataLayer: data)
        TealiumHelper.shared.tealium?.track(tealiumView)
    }
    
    class func trackEvent(title: String, data: [String: Any]?) {
        let tealiumEvent = TealiumEvent(title, dataLayer: data)
        TealiumHelper.shared.tealium?.track(tealiumEvent)
    }
}
