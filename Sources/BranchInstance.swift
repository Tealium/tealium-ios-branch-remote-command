//
//  BranchInstance.swift
//  TealiumBranch
//
//  Created by Tyler Rister on 10/18/21.
//

import Branch
import Foundation
#if COCOAPODS
    import TealiumSwift
#else
    import TealiumCore
    import TealiumRemoteCommands
#endif


public protocol BranchCommand {
    func initialize(payload: [String: Any])
    func sendEvent(eventName: String, parameters: [String: Any])
    func sendEvent(event: BranchStandardEvent, parameters: [String: Any])
    func setIdentity(id: String)
    func setOptOut(opt: Bool)
    func logout()
}

public class BranchInstance: BranchCommand, TealiumRegistration {
    
    public init() { }
    
    public func initialize(payload: [String: Any]) {
        let branchInstance = Branch.getInstance()
        branchInstance.initSession(launchOptions: [:])
        
        let settings = payload[BranchConstants.Config.settings] as? [String: Any]
        let logging = settings?[BranchConstants.Config.enableLogging]
        let branchKey = settings?[BranchConstants.Config.devKey]
        
        if let branchKey = branchKey as? String {
            Branch.setBranchKey(branchKey)
        }
        
        if let logging = logging as? Bool {
            if logging {
                branchInstance.enableLogging()
            }
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
        Branch.getInstance().setIdentity(id)
    }
    
    public func setOptOut(opt: Bool) {
        Branch.setTrackingDisabled(opt)
    }
    
    public func logout() {
        Branch.getInstance().logout()
    }
    
    public func registerPushToken(_ token: String) {
        
    }
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Branch.getInstance().handlePushNotification(userInfo)
    }
    
}
