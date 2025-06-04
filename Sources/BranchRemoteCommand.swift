//
//  BranchRemoteCommand.swift
//  TealiumBranch
//
//  Created by Tyler Rister on 10/18/21.
//

import Foundation
import BranchSDK
import UIKit

#if COCOAPODS
    import TealiumSwift
#else
    import TealiumCore
    import TealiumRemoteCommands
#endif

public class BranchRemoteCommand: RemoteCommand {
    
    override public var version: String? {
        return BranchConstants.version
    }
    
    var branchInstance: BranchCommand
    var debug = false
    private let launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    
    public init(branchInstance: BranchCommand = BranchInstance(), 
                type: RemoteCommandType = .webview,
                launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        self.branchInstance = branchInstance
        self.launchOptions = launchOptions
        weak var weakSelf: BranchRemoteCommand?
        super.init(commandId: BranchConstants.commandId, 
                description: BranchConstants.description, 
                type: type, 
                completion: { response in
                    guard let payload = response.payload else {
                        return
                    }
                    weakSelf?.processRemoteCommand(with: payload)
                })
        weakSelf = self
    }
    
    public func onReady(_ onReady: @escaping () -> Void) {
        self.branchInstance.onReady(onReady)
    }
    
    func processRemoteCommand(with payload: [String: Any]) {
        guard let command = payload[BranchConstants.commandName] as? String else {
            return
        }
        
        if let tagDebug = payload[BranchConstants.debug] as? Bool,
           tagDebug == true {
            debug = true
        }
        
        let commands = command.split(separator: BranchConstants.seperator)
        let branchCommands = commands.map { $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) }
        
        branchCommands.forEach { command in
            switch (command) {
            case BranchConstants.Commands.initialize:
                branchInstance.initialize(payload: payload, launchOptions: self.launchOptions)
            case BranchConstants.Commands.setIdentity:
                guard let id = payload[BranchConstants.EventKeys.userId] as? String else {
                    if debug {
                        print("\(BranchConstants.errorPrefix)setIdentity - \(BranchConstants.EventKeys.userId) must be populated.")
                    }
                    break
                }
                branchInstance.setIdentity(id: id)
            case BranchConstants.Commands.logout:
                branchInstance.logout()
            case BranchConstants.Commands.handleDeepLink:
                guard let urlString = payload[BranchConstants.EventKeys.deepLinkURL] as? String else {
                    if debug {
                        print("\(BranchConstants.errorPrefix)handleDeepLink - deep_link_url must be provided")
                    }
                    break
                }
                let _ = branchInstance.handleDeepLink(url: urlString)
            case BranchConstants.Commands.handleATTAuthorizationStatus:
                guard let status: UInt = TypeChecker.getTypedPropertyForValue(value: payload[BranchConstants.EventKeys.attStatus] ?? 0) else {
                    if debug {
                        print("\(BranchConstants.errorPrefix)handleATTAuthorizationStatus - att_status must be provided")
                    }
                    break
                }
                branchInstance.handleATTAuthorizationStatus(status: status)
            case BranchConstants.Commands.setRequestMetadataKey:
                guard let key = payload[BranchConstants.EventKeys.metadataKey] as? String,
                      let value = payload[BranchConstants.EventKeys.metadataValue] as? String else {
                    if debug {
                        print("\(BranchConstants.errorPrefix)setRequestMetadataKey - metadata_key and metadata_value must be provided")
                    }
                    break
                }
                branchInstance.setRequestMetadataKey(key: key, value: value)
            case BranchConstants.Commands.setConsumerProtectionAttributionLevel:
                guard let level = payload[BranchConstants.EventKeys.consumerProtectionLevel] as? String else {
                    if debug {
                        print("\(BranchConstants.errorPrefix)setConsumerProtectionAttributionLevel - consumer_protection_level must be provided")
                    }
                    break
                }
                branchInstance.setConsumerProtectionAttributionLevel(level: level)
            case BranchConstants.Commands.setCustomServerURL:
                guard let url = payload[BranchConstants.EventKeys.customServerURL] as? String else {
                    if debug {
                        print("\(BranchConstants.errorPrefix)setCustomServerURL - custom_server_url must be provided")
                    }
                    break
                }
                branchInstance.setCustomServerURL(url: url)
            case BranchConstants.Commands.setSafetrackAPIURL:
                guard let url = payload[BranchConstants.EventKeys.safetrackAPIURL] as? String else {
                    if debug {
                        print("\(BranchConstants.errorPrefix)setSafetrackAPIURL - safetrack_api_url must be provided")
                    }
                    break
                }
                branchInstance.setSafetrackAPIURL(url: url)
            case BranchConstants.Commands.useEUEndpoints:
                branchInstance.useEUEndpoints()
            case BranchConstants.Commands.setODMInfo:
                guard let odmInfo = payload[BranchConstants.EventKeys.odmInfo] as? String else {
                    if debug {
                        print("\(BranchConstants.errorPrefix)setODMInfo - odm_info (String) must be provided")
                    }
                    break
                }
                var firstOpenTimestamp: Date? = nil
                if let timestamp = payload[BranchConstants.EventKeys.firstOpenTimestamp] as? Double {
                    firstOpenTimestamp = Date(timeIntervalSince1970: timestamp / 1000.0)
                }
                branchInstance.setODMInfo(info: odmInfo, firstOpenTimestamp: firstOpenTimestamp)
            // DMA Compliance & Custom Logging (3.2.0+)
            case BranchConstants.Commands.setDMACompliance:
                let eeaRegion = payload[BranchConstants.EventKeys.dmaEEARegion] as? Bool ?? false
                let adPersonalizationConsent = payload[BranchConstants.EventKeys.dmaAdPersonalizationConsent] as? Bool ?? false
                let adUserDataUsageConsent = payload[BranchConstants.EventKeys.dmaAdUserDataUsageConsent] as? Bool ?? false
                branchInstance.setDMACompliance(eeaRegion: eeaRegion, 
                                               adPersonalizationConsent: adPersonalizationConsent, 
                                               adUserDataUsageConsent: adUserDataUsageConsent)
            case BranchConstants.Commands.enableLoggingAtLevel:
                let logLevel = payload[BranchConstants.EventKeys.logLevel] as? String ?? "debug"
                branchInstance.enableLoggingAtLevel(level: logLevel)
            // Partner Parameters & Network Configuration
            case BranchConstants.Commands.addFacebookPartnerParameter:
                guard let name = payload[BranchConstants.EventKeys.parameterName] as? String,
                      let value = payload[BranchConstants.EventKeys.parameterValue] as? String else {
                    if debug {
                        print("\(BranchConstants.errorPrefix)addFacebookPartnerParameter - parameter_name and parameter_value must be provided")
                    }
                    break
                }
                branchInstance.addFacebookPartnerParameter(name: name, value: value)
            case BranchConstants.Commands.addSnapPartnerParameter:
                guard let name = payload[BranchConstants.EventKeys.parameterName] as? String,
                      let value = payload[BranchConstants.EventKeys.parameterValue] as? String else {
                    if debug {
                        print("\(BranchConstants.errorPrefix)addSnapPartnerParameter - parameter_name and parameter_value must be provided")
                    }
                    break
                }
                branchInstance.addSnapPartnerParameter(name: name, value: value)
            case BranchConstants.Commands.clearPartnerParameters:
                branchInstance.clearPartnerParameters()
            case BranchConstants.Commands.setRetryInterval:
                guard let interval = payload[BranchConstants.EventKeys.retryInterval] as? Double else {
                    if debug {
                        print("\(BranchConstants.errorPrefix)setRetryInterval - retry_interval must be provided")
                    }
                    break
                }
                branchInstance.setRetryInterval(interval: interval)
            case BranchConstants.Commands.setMaxRetries:
                guard let retries = payload[BranchConstants.EventKeys.maxRetries] as? Int else {
                    if debug {
                        print("\(BranchConstants.errorPrefix)setMaxRetries - max_retries must be provided")
                    }
                    break
                }
                branchInstance.setMaxRetries(retries: retries)
            case BranchConstants.Commands.setNetworkTimeout:
                guard let timeout = payload[BranchConstants.EventKeys.networkTimeout] as? Double else {
                    if debug {
                        print("\(BranchConstants.errorPrefix)setNetworkTimeout - network_timeout must be provided")
                    }
                    break
                }
                branchInstance.setNetworkTimeout(timeout: timeout)
            case BranchConstants.Commands.disableAdNetworkCallouts:
                let disable = payload[BranchConstants.EventKeys.disableAdNetworkCallouts] as? Bool ?? false
                branchInstance.disableAdNetworkCallouts(disable: disable)
            case BranchConstants.Commands.resetUserSession:
                branchInstance.resetUserSession()
            // Additional Configuration & Debugging
            case BranchConstants.Commands.validateSDKIntegration:
                branchInstance.validateSDKIntegration()
            case BranchConstants.Commands.setDeepLinkDebugMode:
                guard let debugParams = payload[BranchConstants.EventKeys.debugParams] as? [String: Any] else {
                    if debug {
                        print("\(BranchConstants.errorPrefix)setDeepLinkDebugMode - debug_params must be provided")
                    }
                    break
                }
                branchInstance.setDeepLinkDebugMode(debugParams: debugParams)
            case BranchConstants.Commands.setAllowedSchemes:
                guard let schemes = payload[BranchConstants.EventKeys.allowedSchemes] as? [String] else {
                    if debug {
                        print("\(BranchConstants.errorPrefix)setAllowedSchemes - allowed_schemes array must be provided")
                    }
                    break
                }
                branchInstance.setAllowedSchemes(schemes: schemes)
            case BranchConstants.Commands.addAllowedScheme:
                guard let scheme = payload[BranchConstants.EventKeys.scheme] as? String else {
                    if debug {
                        print("\(BranchConstants.errorPrefix)addAllowedScheme - scheme must be provided")
                    }
                    break
                }
                branchInstance.addAllowedScheme(scheme: scheme)
            case BranchConstants.Commands.setUrlPatternsToIgnore:
                guard let patterns = payload[BranchConstants.EventKeys.urlPatterns] as? [String] else {
                    if debug {
                        print("\(BranchConstants.errorPrefix)setUrlPatternsToIgnore - url_patterns array must be provided")
                    }
                    break
                }
                branchInstance.setUrlPatternsToIgnore(patterns: patterns)
            case BranchConstants.Commands.setAppClipAppGroup:
                guard let appGroup = payload[BranchConstants.EventKeys.appGroup] as? String else {
                    if debug {
                        print("\(BranchConstants.errorPrefix)setAppClipAppGroup - app_group must be provided")
                    }
                    break
                }
                branchInstance.setAppClipAppGroup(appGroup: appGroup)
            case BranchConstants.Commands.registerPluginName:
                guard let name = payload[BranchConstants.EventKeys.pluginName] as? String,
                      let version = payload[BranchConstants.EventKeys.pluginVersion] as? String else {
                    if debug {
                        print("\(BranchConstants.errorPrefix)registerPluginName - plugin_name and plugin_version must be provided")
                    }
                    break
                }
                branchInstance.registerPluginName(name: name, version: version)
            case BranchConstants.Commands.setReferrerGbraidValidityWindow:
                guard let validityWindow = payload[BranchConstants.EventKeys.gbraidValidityWindow] as? Double else {
                    if debug {
                        print("\(BranchConstants.errorPrefix)setReferrerGbraidValidityWindow - gbraid_validity_window must be provided")
                    }
                    break
                }
                branchInstance.setReferrerGbraidValidityWindow(validityWindow: validityWindow)
            
            // Content Indexing Functions
            case BranchConstants.Commands.listOnSpotlight:
                guard let buoData = payload[BranchConstants.EventKeys.branchUniversalObjectProperties] as? [String: Any] else {
                    if debug {
                        print("\(BranchConstants.errorPrefix)listOnSpotlight - BUO data must be provided")
                    }
                    break
                }
                branchInstance.listOnSpotlight(buo: buoData)
            case BranchConstants.Commands.removeFromSpotlight:
                guard let buoData = payload[BranchConstants.EventKeys.branchUniversalObjectProperties] as? [String: Any] else {
                    if debug {
                        print("\(BranchConstants.errorPrefix)removeFromSpotlight - BUO data must be provided")
                    }
                    break
                }
                branchInstance.removeFromSpotlight(buo: buoData)
            case BranchConstants.Commands.clearUserIdentity:
                branchInstance.clearUserIdentity()
            default:
                if let standardEvent = BranchStandardEvent.eventFromEventName(eventName: command) {
                    branchInstance.sendEvent(event: standardEvent, parameters: payload)
                } else {
                    branchInstance.sendCustomEvent(eventName: command, parameters: payload)
                }
            }
        }
    }
}

extension BranchStandardEvent {
    static func eventFromEventName(eventName: String) -> BranchStandardEvent? {
        if let branchEvent = BranchConstants.StandardEventNames(rawValue: eventName) {
            switch (branchEvent) {
            case .achievelevel:
                return BranchStandardEvent.achieveLevel
            case .addpaymentinfo:
                return BranchStandardEvent.addPaymentInfo
            case .addtocart:
                return BranchStandardEvent.addToCart
            case .addtowishlist:
                return BranchStandardEvent.addToWishlist
            case .clickad:
                return BranchStandardEvent.clickAd
            case .completetutorial:
                return BranchStandardEvent.completeTutorial
            case .completeregistration:
                return BranchStandardEvent.completeRegistration
            case .initiatestream:
                return BranchStandardEvent.initiateStream
            case .completestream:
                return BranchStandardEvent.completeStream
            case .initiatepurchase:
                return BranchStandardEvent.initiatePurchase
            case .invite:
                return BranchStandardEvent.invite
            case .login:
                return BranchStandardEvent.login
            case .purchase:
                return BranchStandardEvent.purchase
            case .rate:
                return BranchStandardEvent.rate
            case .reserve:
                return BranchStandardEvent.reserve
            case .search:
                return BranchStandardEvent.search
            case .share:
                return BranchStandardEvent.share
            case .spendcredits:
                return BranchStandardEvent.spendCredits
            case .starttrial:
                return BranchStandardEvent.startTrial
            case .subscribe:
                return BranchStandardEvent.subscribe
            case .unlockachievement:
                return BranchStandardEvent.unlockAchievement
            case .viewad:
                return BranchStandardEvent.viewAd
            case .viewcart:
                return BranchStandardEvent.viewCart
            case .viewitem:
                return BranchStandardEvent.viewItem
            case .viewitems:
                return BranchStandardEvent.viewItems
            case .optin:
                return BranchStandardEvent.optIn
            case .optout:
                return BranchStandardEvent.optOut
            }
        } else {
            return nil
        }
    }
}
