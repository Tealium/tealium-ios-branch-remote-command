//
//  BranchInstance.swift
//  TealiumBranch
//
//  Created by Tyler Rister on 10/18/21.
//

import BranchSDK
import Foundation
#if COCOAPODS
    import TealiumSwift
#else
    import TealiumCore
    import TealiumRemoteCommands
#endif


public protocol BranchCommand {
    func onReady(_ onReady: @escaping () -> Void)
    func initialize(payload: [String: Any], launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    func sendEvent(event: BranchStandardEvent, parameters: [String: Any])
    func sendCustomEvent(eventName: String, parameters: [String: Any])
    func setIdentity(id: String)
    func logout()
    func handleDeepLink(url: String) -> Bool
    func listOnSpotlight(buo: [String: Any])
    func removeFromSpotlight(buo: [String: Any])
    func clearUserIdentity()
    func handleATTAuthorizationStatus(status: UInt)
    func setRequestMetadataKey(key: String, value: String)
    func setConsumerProtectionAttributionLevel(level: String)
    func setCustomServerURL(url: String)
    func setSafetrackAPIURL(url: String)
    func addFacebookPartnerParameter(name: String, value: String)
    func addSnapPartnerParameter(name: String, value: String)
    func clearPartnerParameters()
    func setNetworkTimeout(timeout: Double)
    func setMaxRetries(retries: Int)
    func setRetryInterval(interval: Double)
    func setDMACompliance(eeaRegion: Bool, adPersonalizationConsent: Bool, adUserDataUsageConsent: Bool)
    func enableLoggingAtLevel(level: String)
    func setODMInfo(info: String, firstOpenTimestamp: Date?)
    func useEUEndpoints()
    func disableAdNetworkCallouts(disable: Bool)
    func resetUserSession()
    func validateSDKIntegration()
    func setDeepLinkDebugMode(debugParams: [String: Any])
    func setAllowedSchemes(schemes: [String])
    func addAllowedScheme(scheme: String)
    func setUrlPatternsToIgnore(patterns: [String])
    func setAppClipAppGroup(appGroup: String)
    func registerPluginName(name: String, version: String)
    func setReferrerGbraidValidityWindow(validityWindow: Double)
    func handlePushNotification(userInfo: [AnyHashable: Any])
}

public class BranchInstance: BranchCommand {
    
    private var _onReady = TealiumReplaySubject<Void>(cacheSize: 1)
    
    public init() { }
    
    public func initialize(payload: [String: Any], launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        let settings = payload[BranchConstants.Config.settings] as? [String: Any]
        let logging = settings?[BranchConstants.Config.enableLogging]
        let branchKey = settings?[BranchConstants.Config.devKey]
        
        if let customAPIURL = settings?[BranchConstants.Config.branchAPIBaseURL] as? String {
            Branch.setAPIUrl(customAPIURL)
        }
        
        if let consumerProtectionLevel = settings?[BranchConstants.Config.consumerProtectionLevel] as? String {
            setConsumerProtectionAttributionLevel(level: consumerProtectionLevel)
        }
        
        if let checkPasteboard = settings?[BranchConstants.Config.checkPasteboardOnInstall] as? Bool,
           checkPasteboard == true {
            Branch.getInstance().checkPasteboardOnInstall()
        }
        
        if let branchKey = branchKey as? String {
            Branch.setBranchKey(branchKey)
        }
        
        DispatchQueue.main.async {
            let branchInstance = Branch.getInstance()
            branchInstance.initSession(launchOptions: launchOptions ?? [:])
            
            if let logging = logging as? Bool {
                if logging {
                    Branch.enableLogging()
                }
            }
            
            self._onReady.publish()
        }
    }

    public func onReady(_ onReady: @escaping () -> Void) {
        TealiumQueues.secureMainThreadExecution {
            self._onReady.subscribeOnce(onReady)
        }
    }
    
    public func sendCustomEvent(eventName: String, parameters: [String: Any]) {
        let event = BranchEvent.customEvent(withName: eventName)
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
    
    public func logout() {
        Branch.getInstance().logout()
    }
    
    public func listOnSpotlight(buo: [String: Any]) {
        let branchUniversalObject = BranchUniversalObject()
        branchUniversalObject.addProperties(properties: buo)
        branchUniversalObject.listOnSpotlight()
    }
    
    public func removeFromSpotlight(buo: [String: Any]) {
        let branchUniversalObject = BranchUniversalObject()
        branchUniversalObject.addProperties(properties: buo)
        branchUniversalObject.removeFromSpotlight()
    }
    
    public func handleDeepLink(url: String) -> Bool {
        guard let nsUrl = URL(string: url) else { return false }
        return Branch.getInstance().handleDeepLink(nsUrl)
    }

    public func clearUserIdentity() {
        Branch.getInstance().logout()
    }
    
    public func handleATTAuthorizationStatus(status: UInt) {
        Branch.getInstance().handleATTAuthorizationStatus(status)
    }
    
    public func setRequestMetadataKey(key: String, value: String) {
        Branch.getInstance().setRequestMetadataKey(key, value: value)
    }
    
    public func setConsumerProtectionAttributionLevel(level: String) {
        if level.lowercased() == "none" {
            Branch.getInstance().setConsumerProtectionAttributionLevel(.none)
        } else if level.lowercased() == "reduced" {
            Branch.getInstance().setConsumerProtectionAttributionLevel(.reduced)
        } else if level.lowercased() == "minimal" {
            Branch.getInstance().setConsumerProtectionAttributionLevel(.minimal)
        } else {
            Branch.getInstance().setConsumerProtectionAttributionLevel(.full)
        }
    }
    
    public func setCustomServerURL(url: String) {
        Branch.setAPIUrl(url)
    }
    
    public func setSafetrackAPIURL(url: String) {
        Branch.setSafetrackAPIURL(url)
    }
    
    public func addFacebookPartnerParameter(name: String, value: String) {
        Branch.getInstance().addFacebookPartnerParameter(withName: name, value: value)
    }
    
    public func addSnapPartnerParameter(name: String, value: String) {
        Branch.getInstance().addSnapPartnerParameter(withName: name, value: value)
    }
    
    public func clearPartnerParameters() {
        Branch.getInstance().clearPartnerParameters()
    }
    
    public func setNetworkTimeout(timeout: Double) {
        Branch.getInstance().setNetworkTimeout(timeout)
    }
    
    public func setMaxRetries(retries: Int) {
        Branch.getInstance().setMaxRetries(retries)
    }
    
    public func setRetryInterval(interval: Double) {
        Branch.getInstance().setRetryInterval(interval)
    }
    
    public func setDMACompliance(eeaRegion: Bool, adPersonalizationConsent: Bool, adUserDataUsageConsent: Bool) {
        Branch.setDMAParamsForEEA(eeaRegion, 
                                  adPersonalizationConsent: adPersonalizationConsent, 
                                  adUserDataUsageConsent: adUserDataUsageConsent)
    }
    
    public func enableLoggingAtLevel(level: String) {
        if let logLevelMapping = BranchConstants.LogLevelMapping(rawValue: level.lowercased()) {
            Branch.enableLogging(at: logLevelMapping.branchLogLevel, withCallback: nil)
        } else {
            Branch.enableLogging(at: .debug, withCallback: nil)
        }
    }
    
    public func setODMInfo(info: String, firstOpenTimestamp: Date?) {
        let timestamp = firstOpenTimestamp ?? Date()
        Branch.setODMInfo(info, andFirstOpenTimestamp: timestamp)
    }
    
    public func useEUEndpoints() {
        Branch.getInstance().useEUEndpoints()
    }
    
    public func disableAdNetworkCallouts(disable: Bool) {
        Branch.getInstance().disableAdNetworkCallouts(disable)
    }

    public func resetUserSession() {
        Branch.getInstance().resetUserSession()
    }
    
    public func validateSDKIntegration() {
        Branch.getInstance().validateSDKIntegration()
    }
    
    public func setDeepLinkDebugMode(debugParams: [String: Any]) {
        Branch.getInstance().setDeepLinkDebugMode(debugParams)
    }
    
    public func setAllowedSchemes(schemes: [String]) {
        Branch.getInstance().setAllowedSchemes(schemes)
    }
    
    public func addAllowedScheme(scheme: String) {
        Branch.getInstance().addAllowedScheme(scheme)
    }
    
    public func setUrlPatternsToIgnore(patterns: [String]) {
        Branch.getInstance().setUrlPatternsToIgnore(patterns)
    }
    
    public func setAppClipAppGroup(appGroup: String) {
        Branch.getInstance().setAppClipAppGroup(appGroup)
    }
    
    public func registerPluginName(name: String, version: String) {
        Branch.getInstance().registerPluginName(name, version: version)
    }
    
    public func setReferrerGbraidValidityWindow(validityWindow: Double) {
        Branch.setReferrerGbraidValidityWindow(validityWindow)
    }
    
    public func handlePushNotification(userInfo: [AnyHashable: Any]) {
        Branch.getInstance().handlePushNotification(userInfo)
    }
}
