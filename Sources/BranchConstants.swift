//
//  BranchConstants.swift
//  TealiumBranch
//
//  Created by Tyler Rister on 10/18/21.
//

import Foundation

enum BranchConstants {
    static let commandId = "branch"
    static let description = "Branch Remote Command"
    static let commandName = "command_name"
    static let debug = "debug"
    static let seperator: Character = ","
    static let errorPRefix = "TealiumBranch Error: "
    static let version = "1.1.0"
    
    struct EventKeys {
        static let branchUniversalObjectProperties = "buo"
        static let branchMetadataProperties = "metadata"
        static let event = "event"
        static let userId = "user_id"
        static let linkProperties = "link"
    }
    
    struct Config {
        static let settings = "settings"
        static let devKey = "branch_dev_key"
        static let enableLogging = "enable_logging"
        static let collectDeviceId = "collect_device_id"
    }
    
    enum StandardEventNames: String {
        case achievelevel = "achievelevel"
        case addpaymentinfo = "addpaymentinfo"
        case addtocart = "addtocart"
        case addtowishlist = "addtowishlist"
        case clickad = "clickad"
        case completetutorial = "completetutorial"
        case completeregistration = "completeregistration"
        case initiatepurchase = "initiatepurchase"
        case invite = "invite"
        case login = "login"
        case purchase = "purchase"
        case rate = "rate"
        case reserve = "reserve"
        case search = "search"
        case share = "share"
        case spendcredits = "spendcredits"
        case starttrial = "starttrial"
        case subscribe = "subscribe"
        case unlockachievement = "unlockachievement"
        case viewad = "viewad"
        case viewcart = "viewcart"
        case viewitem = "viewitem"
        case viewitems = "viewitems"
    }
    
    struct DeepLinkProperties {
        static let channel = "channel"
        static let feature = "feature"
        static let campaign = "campaign"
        static let stage = "stage"
        static let duration = "duration"
        static let controlParameters = "control_parameters"
    }
    
    struct BranchUniversalObjectProperties {
        static let canonicalIdentifier = "canonical_identifier"
        static let canonicalUrl = "canonical_url"
        static let title = "title"
        static let description = "description"
        static let imageUrl = "image_url"
        static let contentMetadata = "content_metadata"
    }
    
    struct BranchMetadataProperties {
        static let quantity = "quantity"
        static let price = "price"
        static let currencyType = "currency_type"
        static let sku = "sku"
        static let productName = "product_name"
        static let productBrand = "product_brand"
        static let productCategory = "product_category"
        static let condition = "condition"
        static let productVariant = "product_variant"
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
        static let affiliation = "affiliation"
        static let coupon = "coupon"
        static let currency = "currency"
        static let tax = "tax"
        static let revenue = "revenue"
        static let description = "description"
        static let searchQuery = "search_query"
    }
    
    struct Commands {
        static let initialize = "initialize"
        static let setUserId = "setuserid"
        static let logout = "logout"
    }
}
