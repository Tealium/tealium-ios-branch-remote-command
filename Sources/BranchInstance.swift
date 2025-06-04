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
    
    // Deep Link Handling Functions
    func handleDeepLink(url: String) -> Bool
    
    // Content Indexing Functions (simple versions only)
    func listOnSpotlight(buo: [String: Any])
    func removeFromSpotlight(buo: [String: Any])
    
    // User Data Functions
    func clearUserIdentity()
    
    // Modern Branch Features (1.39.0+)
    func handleATTAuthorizationStatus(status: UInt)
    func setRequestMetadataKey(key: String, value: String) 
    
    // Consumer Protection & Modern Features (3.0.0+)
    func setConsumerProtectionAttributionLevel(level: String)
    func setCustomServerURL(url: String)
    func setSafetrackAPIURL(url: String)
    
    // Partner Parameters Support
    func addFacebookPartnerParameter(name: String, value: String)
    func addSnapPartnerParameter(name: String, value: String)
    func clearPartnerParameters()
    
    // Network & Timing Configuration
    func setNetworkTimeout(timeout: Double)
    func setMaxRetries(retries: Int)
    func setRetryInterval(interval: Double)
    
    // DMA Compliance & Custom Logging (3.2.0+)
    func setDMACompliance(eeaRegion: Bool, adPersonalizationConsent: Bool, adUserDataUsageConsent: Bool)
    func enableLoggingAtLevel(level: String)
    
    // ODM Info Support
    func setODMInfo(info: String, firstOpenTimestamp: Date?)
    
    // EU Endpoints
    func useEUEndpoints()
    
    // Ad Network Configuration
    func disableAdNetworkCallouts(disable: Bool)
    
    // Additional Configuration & Debugging
    func resetUserSession()
    func validateSDKIntegration()
    func setDeepLinkDebugMode(debugParams: [String: Any])
    func setAllowedSchemes(schemes: [String])
    func addAllowedScheme(scheme: String)
    func setUrlPatternsToIgnore(patterns: [String])
    func setAppClipAppGroup(appGroup: String)
    func registerPluginName(name: String, version: String)
    func setReferrerGbraidValidityWindow(validityWindow: Double)
}

public class BranchInstance: BranchCommand, TealiumRegistration {
    
    private var _onReady = TealiumReplaySubject<Void>(cacheSize: 1)
    
    public init() { }
    
    public func initialize(payload: [String: Any], launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        let settings = payload[BranchConstants.Config.settings] as? [String: Any]
        let logging = settings?[BranchConstants.Config.enableLogging]
        let branchKey = settings?[BranchConstants.Config.devKey]
        
        // SDK-3.4.0: Support for setting Branch API base URL through branch.json
        if let customAPIURL = settings?[BranchConstants.Config.branchAPIBaseURL] as? String {
            Branch.setAPIUrl(customAPIURL)
        }
        
        // SDK-3.8.0: Support for setting Consumer Protection Attribution Level through branch.json
        if let consumerProtectionLevel = settings?[BranchConstants.Config.consumerProtectionLevel] as? String {
            setConsumerProtectionAttributionLevel(level: consumerProtectionLevel)
        }
        
        // CORE-2088: Check pasteboard on install (must be before initSession)
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
    
    public func registerPushToken(_ token: String) {
        
    }
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Branch.getInstance().handlePushNotification(userInfo)
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
    
    // MARK: - User Data Functions
    
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
    
    // Ad Network Configuration
    public func disableAdNetworkCallouts(disable: Bool) {
        Branch.getInstance().disableAdNetworkCallouts(disable)
    }
    
    // Additional Configuration & Debugging
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
}
