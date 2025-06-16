//
//  BranchExtensions.swift
//  TealiumBranch
//
//  Created by Tyler Rister on 10/18/21.
//

import Branch
import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}

protocol EncodeFromString {
    associatedtype T
    static func encodeFrom(_ string: String) -> T?
}

extension Int: EncodeFromString {
    typealias T = Int
    static func encodeFrom(_ string: String) -> Int? {
        return Int(string)
    }
}

extension UInt: EncodeFromString {
    typealias T = UInt
    static func encodeFrom(_ string: String) -> UInt? {
        return UInt(string)
    }
}

extension Double: EncodeFromString {
    typealias T = Double
    static func encodeFrom(_ string: String) -> Double? {
        return Double(string)
    }
}

extension String: EncodeFromString {
    typealias T = String
    static func encodeFrom(_ string: String) -> String? {
        return string
    }
}

class TypeChecker {
    static func getTypedPropertyForValue<T: EncodeFromString>(value: Any) -> (T?) {
        if let value = value as? T {
            return value
        } else if let value = value as? String {
            return T.encodeFrom(value) as? T
        } else {
            return nil
        }
    }
}

extension BranchEvent {
    func addEventProperties(properties: [String: Any]) {
        properties.forEach { key, value in
            switch (key) {
            case BranchConstants.BranchEventProperties.affiliation:
                self.affiliation = TypeChecker.getTypedPropertyForValue(value: value)
            case BranchConstants.BranchEventProperties.coupon:
                self.coupon = TypeChecker.getTypedPropertyForValue(value: value)
            case BranchConstants.BranchEventProperties.currency:
                let currencyString: String? = TypeChecker.getTypedPropertyForValue(value: value)
                guard let currencyString = currencyString else {
                    break
                }
                self.currency = BNCCurrency(rawValue: currencyString)
            case BranchConstants.BranchEventProperties.tax:
                guard let doubleValue: Double = TypeChecker.getTypedPropertyForValue(value: value) else {
                    break
                }
                self.tax = NSDecimalNumber(value: doubleValue)
            case BranchConstants.BranchEventProperties.revenue:
                guard let doubleValue: Double = TypeChecker.getTypedPropertyForValue(value: value) else {
                    break
                }
                self.revenue = NSDecimalNumber(value: doubleValue)
            case BranchConstants.BranchEventProperties.description:
                self.eventDescription = TypeChecker.getTypedPropertyForValue(value: value)
            case BranchConstants.BranchEventProperties.searchQuery:
                self.searchQuery = TypeChecker.getTypedPropertyForValue(value: value)
            default:
                self.customData[key] = TypeChecker.getTypedPropertyForValue(value: value)
            }
        }
    }
}

extension BranchContentMetadata {
    func addMetadataProperties(metadata: [String: Any]) {
        metadata.forEach { key, value in
            switch (key) {
            case BranchConstants.BranchMetadataProperties.quantity:
                let doubleValue: Double? = TypeChecker.getTypedPropertyForValue(value: value)
                guard let doubleValue = doubleValue else {
                    break
                }
                self.quantity = doubleValue
            case BranchConstants.BranchMetadataProperties.price:
                guard let doubleValue: Double = TypeChecker.getTypedPropertyForValue(value: value) else {
                    break
                }
                self.price = NSDecimalNumber(value: doubleValue)
            case BranchConstants.BranchMetadataProperties.currencyType:
                guard let value: String = TypeChecker.getTypedPropertyForValue(value: value) else {
                    break
                }
                self.currency = BNCCurrency.init(rawValue: value)
            case BranchConstants.BranchMetadataProperties.sku:
                self.sku = TypeChecker.getTypedPropertyForValue(value: value)
            case BranchConstants.BranchMetadataProperties.productName:
                self.productName = TypeChecker.getTypedPropertyForValue(value: value)
            case BranchConstants.BranchMetadataProperties.productBrand:
                self.productBrand = TypeChecker.getTypedPropertyForValue(value: value)
            case BranchConstants.BranchMetadataProperties.productCategory:
                guard let value: String = TypeChecker.getTypedPropertyForValue(value: value) else {
                    break
                }
                self.productCategory = BNCProductCategory.init(rawValue: value.capitalizingFirstLetter())
            case BranchConstants.BranchMetadataProperties.condition:
                guard let value: String = TypeChecker.getTypedPropertyForValue(value: value) else {
                    break
                }
                self.condition = BranchCondition.init(rawValue: value.uppercased())
            case BranchConstants.BranchMetadataProperties.productVariant:
                self.productVariant = TypeChecker.getTypedPropertyForValue(value: value)
            case BranchConstants.BranchMetadataProperties.rating:
                guard let doubleValue: Double = TypeChecker.getTypedPropertyForValue(value: value) else {
                    break
                }
                self.rating = doubleValue
            case BranchConstants.BranchMetadataProperties.ratingAverage:
                guard let doubleValue: Double = TypeChecker.getTypedPropertyForValue(value: value) else {
                    break
                }
                self.ratingAverage = doubleValue
            case BranchConstants.BranchMetadataProperties.ratingCount:
                guard let intValue: Int = TypeChecker.getTypedPropertyForValue(value: value) else {
                    break
                }
                self.ratingCount = intValue
            case BranchConstants.BranchMetadataProperties.ratingMax:
                guard let doubleValue: Double = TypeChecker.getTypedPropertyForValue(value: value) else {
                    break
                }
                self.ratingMax = doubleValue
            case BranchConstants.BranchMetadataProperties.addressStreet:
                self.addressStreet = TypeChecker.getTypedPropertyForValue(value: value)
            case BranchConstants.BranchMetadataProperties.addressCity:
                self.addressCity = TypeChecker.getTypedPropertyForValue(value: value)
            case BranchConstants.BranchMetadataProperties.addressRegion:
                self.addressRegion = TypeChecker.getTypedPropertyForValue(value: value)
            case BranchConstants.BranchMetadataProperties.addressCountry:
                self.addressCountry = TypeChecker.getTypedPropertyForValue(value: value)
            case BranchConstants.BranchMetadataProperties.addressPostalCode:
                self.addressPostalCode = TypeChecker.getTypedPropertyForValue(value: value)
            case BranchConstants.BranchMetadataProperties.latitude:
                guard let doubleValue: Double = TypeChecker.getTypedPropertyForValue(value: value) else {
                    break
                }
                self.latitude = doubleValue
            case BranchConstants.BranchMetadataProperties.longitude:
                guard let doubleValue: Double = TypeChecker.getTypedPropertyForValue(value: value) else {
                    break
                }
                self.longitude = doubleValue
            case BranchConstants.BranchMetadataProperties.imageCaptions:
                guard let imageCaptions = value as? [Any] else {
                    break
                }
                self.imageCaptions = NSMutableArray(array: imageCaptions)
            default:
                break
            }
        }
    }
}

extension BranchUniversalObject {
    func addProperties(properties: [String: Any]) {
        properties.forEach { key, value in
            switch (key) {
            case BranchConstants.BranchUniversalObjectProperties.canonicalIdentifier:
                self.canonicalIdentifier = TypeChecker.getTypedPropertyForValue(value: value)
            case BranchConstants.BranchUniversalObjectProperties.canonicalUrl:
                self.canonicalUrl = TypeChecker.getTypedPropertyForValue(value: value)
            case BranchConstants.BranchUniversalObjectProperties.title:
                self.title = TypeChecker.getTypedPropertyForValue(value: value)
            case BranchConstants.BranchUniversalObjectProperties.description:
                self.contentDescription = TypeChecker.getTypedPropertyForValue(value: value)
            case BranchConstants.BranchUniversalObjectProperties.imageUrl:
                self.imageUrl = TypeChecker.getTypedPropertyForValue(value: value)
            default:
                break
            }
        }
    }
}
