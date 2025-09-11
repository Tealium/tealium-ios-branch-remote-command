//
//  TealiumHelper.swift
//  TealiumBranchExample
//
//  Created by Tyler Rister on 10/18/21.
//

import TealiumSwift
import TealiumBranch
import UIKit

enum TealiumConfiguration {
    static let account = "tealiummobile"
    static let profile = "tyler-test"
    static let environment = "dev"
}

final class TealiumHelper {

    static let shared = TealiumHelper()
    
    private init() {
        config.shouldUseRemotePublishSettings = false
        config.batchingEnabled = false
        config.remoteAPIEnabled = true
        config.logLevel = .info
        config.collectors = [Collectors.Lifecycle]
        config.dispatchers = [Dispatchers.RemoteCommands]
    }

    let config = TealiumConfig(account: TealiumConfiguration.account,
                               profile: TealiumConfiguration.profile,
                               environment: TealiumConfiguration.environment)

    var tealium: Tealium?
    
    var branchRemoteCommand: BranchRemoteCommand?
 
    func configure(with launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        branchRemoteCommand = BranchRemoteCommand(
            type: .local(file: "branch", bundle: Bundle.main),
            launchOptions: launchOptions
        )
        
        branchRemoteCommand?.onReady {
            print("Branch SDK is initialized and ready!")
        }
        
        if let branchRemoteCommand = branchRemoteCommand {
            config.addRemoteCommand(branchRemoteCommand)
        }
        
        tealium = Tealium(config: config)
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
