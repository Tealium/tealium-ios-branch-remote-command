//
//  BranchInstance.swift
//  TealiumBranch
//
//  Created by Tyler Rister on 10/18/21.
//

import BranchSDK
import UIKit
#if COCOAPODS
    import TealiumSwift
#else
    import TealiumCore
    import TealiumRemoteCommands
#endif


public protocol BranchCommand {
    func onReady(_ onReady: @escaping () -> Void)
    func initialize(payload: [String: Any], launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    func sendEvent(eventName: String, parameters: [String: Any])
    func sendEvent(event: BranchStandardEvent, parameters: [String: Any])
    func setIdentity(id: String)
    func setOptOut(opt: Bool)
    func logout()
}

public class BranchInstance: BranchCommand, TealiumRegistration {
    
    private var branchInstance: Branch?
    private var _onReady = TealiumReplaySubject<Void>(cacheSize: 1)
    
    public init() { }
    
    // MARK: Initialize
    public func initialize(payload: [String: Any], launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        let settings = payload[BranchConstants.Config.settings] as? [String: Any]
        let logging = settings?[BranchConstants.Config.enableLogging]
        let branchKey = settings?[BranchConstants.Config.devKey]
        
        if let branchKey = branchKey as? String {
            Branch.setBranchKey(branchKey)
        }
        
        // Get the Branch instance
        branchInstance = Branch.getInstance()
        guard let branchInstance else { return }
        
        // Enable logging if requested
        if let logging = logging as? Bool, logging {
            // TODO: remove deprecated method
            branchInstance.enableLogging()
        }
        
        // Initialize session with launch options
        branchInstance.initSession(launchOptions: launchOptions ?? [:])
        
        // Publish ready state following Facebook pattern
        _onReady.publish()
    }

    public func onReady(_ onReady: @escaping () -> Void) {
        TealiumQueues.secureMainThreadExecution {
            self._onReady.subscribeOnce(onReady)
        }
    }
    
    public func sendEvent(eventName: String, parameters: [String: Any]) {
        let event = BranchEvent(name: eventName)
        sendEvent(event: event, parameters: parameters)
    }
    
    public func sendEvent(event: BranchStandardEvent, parameters: [String: Any]) {
        let event = BranchEvent.standardEvent(event)
        sendEvent(event: event, parameters: parameters)
    }
    
    private func sendEvent(event: BranchEvent, parameters: [String : Any]) {
        let eventProperties = parameters[BranchConstants.EventKeys.event]
        if let eventProperties = eventProperties as? [String: Any] {
            event.addEventProperties(properties: eventProperties)
        }
        
        let branchUniversalObject = BranchUniversalObject()
        let universalObjectSettings = parameters[BranchConstants.EventKeys.branchUniversalObjectProperties]
        if let universalObjectSettings = universalObjectSettings as? [String: Any] {
            branchUniversalObject.addProperties(properties: universalObjectSettings)
        }
        
        let metadata = parameters[BranchConstants.EventKeys.branchMetadataProperties]
        if let metadata = metadata as? [String: Any] {
            let contentMetadata = BranchContentMetadata()
            contentMetadata.addMetadataProperties(metadata: metadata)
            branchUniversalObject.contentMetadata = contentMetadata
        }
        event.contentItems = [branchUniversalObject]
        event.logEvent()
    }
    
    public func setIdentity(id: String) {
        branchInstance?.setIdentity(id)
    }
    
    // TODO: remove deprecated method
    public func setOptOut(opt: Bool) {
        Branch.setTrackingDisabled(opt)
    }
    
    public func logout() {
        branchInstance?.logout()
    }
    
    public func registerPushToken(_ token: String) {
        // Push token registration can be implemented as needed
    }

    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        branchInstance?.handlePushNotification(userInfo)
    }
}
