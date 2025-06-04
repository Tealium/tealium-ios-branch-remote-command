//
//  MockBranchInstance.swift
//  TealiumBranchTests
//
//  Created by Tyler Rister on 10/20/21.
//

import Foundation
import BranchSDK
@testable import TealiumBranch

class MockBranchInstance: BranchCommand {

    // Call count tracking
    var initializeCount = 0
    var sendEventCount = 0
    var sendCustomEventCount = 0
    var setIdentityCount = 0
    var logoutCount = 0
    var onReadyCallCount = 0
    var handleDeepLinkCount = 0
    var listOnSpotlightCount = 0
    var removeFromSpotlightCount = 0
    var clearUserIdentityCount = 0
    var handleATTAuthorizationStatusCount = 0
    var setRequestMetadataKeyCount = 0
    var setConsumerProtectionAttributionLevelCount = 0
    var setCustomServerURLCount = 0
    var setSafetrackAPIURLCount = 0
    var addFacebookPartnerParameterCount = 0
    var addSnapPartnerParameterCount = 0
    var clearPartnerParametersCount = 0
    var setNetworkTimeoutCount = 0
    var setMaxRetriesCount = 0
    var setRetryIntervalCount = 0
    var setDMAComplianceCount = 0
    var enableLoggingAtLevelCount = 0
    var setODMInfoCount = 0
    var useEUEndpointsCount = 0
    var disableAdNetworkCalloutsCount = 0
    var resetUserSessionCount = 0
    var validateSDKIntegrationCount = 0
    var setDeepLinkDebugModeCount = 0
    var setAllowedSchemesCount = 0
    var addAllowedSchemeCount = 0
    var setUrlPatternsToIgnoreCount = 0
    var setAppClipAppGroupCount = 0
    var registerPluginNameCount = 0
    var setReferrerGbraidValidityWindowCount = 0
    
    // Stored values for verification
    var lastUserId: String?
    var lastDeepLinkURL: String?
    var lastMetadataKey: String?
    var lastMetadataValue: String?
    var lastConsumerProtectionLevel: String?
    var lastCustomServerURL: String?
    var lastNetworkTimeout: Double?
    var lastMaxRetries: Int?
    
    private var onReadyCallbacks: [() -> Void] = []
    
    func onReady(_ onReady: @escaping () -> Void) {
        onReadyCallCount += 1
        onReadyCallbacks.append(onReady)
        onReady() // Immediately call for testing
    }
    
    func initialize(payload: [String: Any], launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        initializeCount += 1
        // Trigger onReady callbacks after initialization
        for callback in onReadyCallbacks {
            callback()
        }
    }
    
    func sendEvent(event: BranchStandardEvent, parameters: [String: Any]) {
        sendEventCount += 1
    }
    
    func sendCustomEvent(eventName: String, parameters: [String: Any]) {
        sendCustomEventCount += 1
    }
    
    func setIdentity(id: String) {
        setIdentityCount += 1
        lastUserId = id
    }
    
    func logout() {
        logoutCount += 1
    }
    
    func handleDeepLink(url: String) -> Bool {
        handleDeepLinkCount += 1
        lastDeepLinkURL = url
        return true // Mock success
    }
    
    func listOnSpotlight(buo: [String: Any]) {
        listOnSpotlightCount += 1
    }
    
    func removeFromSpotlight(buo: [String: Any]) {
        removeFromSpotlightCount += 1
    }
    
    func clearUserIdentity() {
        clearUserIdentityCount += 1
    }
    
    func handleATTAuthorizationStatus(status: UInt) {
        handleATTAuthorizationStatusCount += 1
    }
    
    func setRequestMetadataKey(key: String, value: String) {
        setRequestMetadataKeyCount += 1
        lastMetadataKey = key
        lastMetadataValue = value
    }
    
    func setConsumerProtectionAttributionLevel(level: String) {
        setConsumerProtectionAttributionLevelCount += 1
        lastConsumerProtectionLevel = level
    }
    
    func setCustomServerURL(url: String) {
        setCustomServerURLCount += 1
        lastCustomServerURL = url
    }
    
    func setSafetrackAPIURL(url: String) {
        setSafetrackAPIURLCount += 1
    }
    
    func addFacebookPartnerParameter(name: String, value: String) {
        addFacebookPartnerParameterCount += 1
    }
    
    func addSnapPartnerParameter(name: String, value: String) {
        addSnapPartnerParameterCount += 1
    }
    
    func clearPartnerParameters() {
        clearPartnerParametersCount += 1
    }
    
    func setNetworkTimeout(timeout: Double) {
        setNetworkTimeoutCount += 1
        lastNetworkTimeout = timeout
    }
    
    func setMaxRetries(retries: Int) {
        setMaxRetriesCount += 1
        lastMaxRetries = retries
    }
    
    func setRetryInterval(interval: Double) {
        setRetryIntervalCount += 1
    }
    
    func setDMACompliance(eeaRegion: Bool, adPersonalizationConsent: Bool, adUserDataUsageConsent: Bool) {
        setDMAComplianceCount += 1
    }
    
    func enableLoggingAtLevel(level: String) {
        enableLoggingAtLevelCount += 1
    }
    
    func setODMInfo(info: String, firstOpenTimestamp: Date?) {
        setODMInfoCount += 1
    }
    
    func useEUEndpoints() {
        useEUEndpointsCount += 1
    }
    
    func disableAdNetworkCallouts(disable: Bool) {
        disableAdNetworkCalloutsCount += 1
    }
    
    func resetUserSession() {
        resetUserSessionCount += 1
    }
    
    func validateSDKIntegration() {
        validateSDKIntegrationCount += 1
    }
    
    func setDeepLinkDebugMode(debugParams: [String: Any]) {
        setDeepLinkDebugModeCount += 1
    }
    
    func setAllowedSchemes(schemes: [String]) {
        setAllowedSchemesCount += 1
    }
    
    func addAllowedScheme(scheme: String) {
        addAllowedSchemeCount += 1
    }
    
    func setUrlPatternsToIgnore(patterns: [String]) {
        setUrlPatternsToIgnoreCount += 1
    }
    
    func setAppClipAppGroup(appGroup: String) {
        setAppClipAppGroupCount += 1
    }
    
    func registerPluginName(name: String, version: String) {
        registerPluginNameCount += 1
    }
    
    func setReferrerGbraidValidityWindow(validityWindow: Double) {
        setReferrerGbraidValidityWindowCount += 1
    }
}
