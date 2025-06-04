//
//  BranchConstants.swift
//  TealiumBranch
//
//  Created by Tyler Rister on 10/18/21.
//

import Foundation
import BranchSDK

enum BranchConstants {
    static let commandId = "branch"
    static let description = "Branch Remote Command"
    static let commandName = "command_name"
    static let debug = "debug"
    static let seperator: Character = ","
    static let errorPrefix = "TealiumBranch Error: "
    static let version = "2.0.0"
    
    struct EventKeys {
        static let branchUniversalObjectProperties = "buo"
        static let branchMetadataProperties = "metadata"
        static let event = "event"
        // Used in setIdentity command
        static let userId = "user_id"
        // Used in handleDeepLink command
        static let deepLinkURL = "deep_link_url"
        // Used in addAllowedScheme command
        static let scheme = "scheme"
        // Used in setAllowedSchemes command
        static let allowedSchemes = "allowed_schemes"
        // Used in setUrlPatternsToIgnore command
        static let urlPatterns = "url_patterns"
        // Used in handleATTAuthorizationStatus command
        static let attStatus = "att_status"
        // Used in setDMACompliance command
        static let dmaEEARegion = "dma_eea_region"
        static let dmaAdPersonalizationConsent = "dma_ad_personalization_consent"
        static let dmaAdUserDataUsageConsent = "dma_ad_user_data_usage_consent"
        // Used in setConsumerProtectionAttributionLevel command
        static let consumerProtectionLevel = "consumer_protection_level"
        // Used in setRequestMetadataKey command
        static let metadataKey = "metadata_key"
        static let metadataValue = "metadata_value"
        // Used in setODMInfo command
        static let odmInfo = "odm_info"
        static let firstOpenTimestamp = "first_open_timestamp"
        // Used in setCustomServerURL command
        static let customServerURL = "custom_server_url"
        // Used in setSafetrackAPIURL command
        static let safetrackAPIURL = "safetrack_api_url"
        // Used in setNetworkTimeout command
        static let networkTimeout = "network_timeout"
        // Used in setMaxRetries command
        static let maxRetries = "max_retries"
        // Used in setRetryInterval command
        static let retryInterval = "retry_interval"
        // Used in disableAdNetworkCallouts command
        static let disableAdNetworkCallouts = "disable_ad_network_callouts"
        // Used in setReferrerGbraidValidityWindow command
        static let gbraidValidityWindow = "gbraid_validity_window"
        // Used in addFacebookPartnerParameter and addSnapPartnerParameter commands
        static let parameterName = "parameter_name"
        static let parameterValue = "parameter_value"
        // Used in enableLoggingAtLevel command
        static let logLevel = "log_level"
        // Used in setDeepLinkDebugMode command
        static let debugParams = "debug_params"
        // Used in setAppClipAppGroup command
        static let appGroup = "app_group"
        // Used in registerPluginName command
        static let pluginName = "plugin_name"
        static let pluginVersion = "plugin_version"
    }
    
    struct Config {
        static let settings = "settings"
        static let devKey = "branch_dev_key"
        static let enableLogging = "enable_logging"
        static let enableDMACompliance = "enable_dma_compliance"
        static let consumerProtectionLevel = "consumer_protection_level"
        static let checkPasteboardOnInstall = "check_pasteboard_on_install"
        static let branchAPIBaseURL = "branch_api_base_url"
    }
    
    enum StandardEventNames: String {
        // Commerce Events
        case addtocart = "addtocart"
        case addtowishlist = "addtowishlist"
        case viewcart = "viewcart"
        case initiatepurchase = "initiatepurchase"
        case addpaymentinfo = "addpaymentinfo"
        case clickad = "clickad"
        case purchase = "purchase"
        case reserve = "reserve"
        case spendcredits = "spendcredits"
        case viewad = "viewad"
        // Content Events
        case search = "search"
        case viewitem = "viewitem"
        case viewitems = "viewitems"
        case rate = "rate"
        case share = "share"
        case initiatestream = "initiatestream"
        case completestream = "completestream"
        // Lifecycle Events
        case completetutorial = "completetutorial"
        case completeregistration = "completeregistration"
        case achievelevel = "achievelevel"
        case unlockachievement = "unlockachievement"
        case invite = "invite"
        case login = "login"
        case starttrial = "starttrial"
        case subscribe = "subscribe"
        case optin = "optin"
        case optout = "optout"
    }
    
    struct BranchUniversalObjectProperties {
        static let canonicalIdentifier = "canonical_identifier"
        static let canonicalUrl = "canonical_url"
        static let title = "title"
        static let contentDescription = "content_description"
        static let imageUrl = "image_url"
        static let keywords = "keywords"
        static let creationDate = "creation_date"
        static let expirationDate = "expiration_date"
        static let locallyIndex = "locally_index"
        static let publiclyIndex = "publicly_index"
    }
    
    struct BranchMetadataProperties {
        static let customMetadata = "custom_metadata"
        static let contentSchema = "content_schema"
        static let price = "price"
        static let currency_type = "currency_type"
        static let quantity = "quantity"
        static let sku = "sku"
        static let productName = "product_name"
        static let productBrand = "product_brand"
        static let productCategory = "product_category"
        static let productVariant = "product_variant"
        static let condition = "condition"
        static let rating = "rating"
        static let ratingAverage = "rating_average"
        static let ratingCount = "rating_count"
        static let ratingMax = "rating_max"
        static let addressStreet = "address_street"
        static let addressCity = "address_city"
        static let addressRegion = "address_region"
        static let addressCountry = "address_country"
        static let addressPostalCode = "address_postal_code"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let imageCaptions = "image_captions"
    }
    
    struct BranchEventProperties {
        static let alias = "alias"
        static let transactionID = "transaction_id"
        static let currency = "currency"
        static let revenue = "revenue"
        static let shipping = "shipping"
        static let tax = "tax"
        static let coupon = "coupon"
        static let affiliation = "affiliation"
        static let eventDescription = "event_description"
        static let searchQuery = "search_query"
        static let adType = "ad_type"
        static let customData = "custom_data"
    }
    
    struct Commands {
        static let initialize = "initialize"
        static let setIdentity = "setidentity"
        static let logout = "logout"
        static let handleDeepLink = "handledeeplink"
        static let listOnSpotlight = "listonspotlight"
        static let removeFromSpotlight = "removefromspotlight"
        static let clearUserIdentity = "clearuseridentity"
        static let handleATTAuthorizationStatus = "handleattauthorizationstatus"
        static let setRequestMetadataKey = "setrequestmetadatakey"
        static let addAllowedScheme = "addallowedscheme"
        static let setAllowedSchemes = "setallowedschemes"
        static let setConsumerProtectionAttributionLevel = "setconsumerprotectionattributionlevel"
        static let addFacebookPartnerParameter = "addfacebookpartnerparameter"
        static let addSnapPartnerParameter = "addsnappartnerparameter"
        static let clearPartnerParameters = "clearpartnerparameters"
        static let setRetryInterval = "setretryinterval"
        static let setCustomServerURL = "setcustomserverurl"
        static let setSafetrackAPIURL = "setsafetrackapi"
        static let useEUEndpoints = "useeuendpoints"
        static let setODMInfo = "setodminfo"
        static let setDMACompliance = "setdmacompliance"
        static let enableLoggingAtLevel = "enableloggingatlevel"
        static let setMaxRetries = "setmaxretries"
        static let setNetworkTimeout = "setnetworktimeout"
        static let disableAdNetworkCallouts = "disableadnetworkcallouts"
        static let setReferrerGbraidValidityWindow = "setreferrergbraidvaliditywindow"
        static let resetUserSession = "resetusersession"
        static let validateSDKIntegration = "validatesdkintegration"
        static let setDeepLinkDebugMode = "setdeeplinkdebugmode"
        static let setUrlPatternsToIgnore = "seturlpatternstoignore"
        static let setAppClipAppGroup = "setappclipappgroup"
        static let registerPluginName = "registerpluginname"
    }
    
    // Type-safe enum mappings
    enum AdTypeMapping: String, CaseIterable {
        case none = "none"
        case banner = "banner"
        case interstitial = "interstitial"
        case rewardedVideo = "rewarded_video"
        case native = "native"
        
        var branchEventAdType: BranchEventAdType {
            switch self {
            case .none: return .none
            case .banner: return .banner
            case .interstitial: return .interstitial
            case .rewardedVideo: return .rewardedVideo
            case .native: return .native
            }
        }
    }
    
    enum LogLevelMapping: String, CaseIterable {
        case verbose = "verbose"
        case debug = "debug"
        case warning = "warning"
        case error = "error"
        
        var branchLogLevel: BranchLogLevel {
            switch self {
            case .verbose: return .verbose
            case .debug: return .debug
            case .warning: return .warning
            case .error: return .error
            }
        }
    }
}
