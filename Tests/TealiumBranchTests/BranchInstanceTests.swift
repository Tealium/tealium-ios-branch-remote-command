//
//  BranchInstanceTests.swift
//  TealiumBranchTests
//
//  Created by Tyler Rister on 10/20/21.
//

import XCTest
@testable import TealiumBranch
import TealiumRemoteCommands
import BranchSDK

class BranchInstanceTests: XCTestCase {

    override func setUp() { 
    }

    override func tearDown() {
    }
    
    // MARK: - Branch Universal Object Extensions Tests
    
    func testBranchUniversalObjectPropertiesMapping() {
        let expect = expectation(description: "Test BUO Properties Mapping")
        let buoData: [String: Any] = [
            "canonical_identifier": "testIdentifier",
            "canonical_url": "testUrl",
            "title": "testTitle",
            "content_description": "testDescription",
            "image_url": "testImageUrl",
            "keywords": ["keyword1", "keyword2", "keyword3"],
            "locally_index": true,
            "publicly_index": false,
            "creation_date": 1640995200000.0, // milliseconds
            "expiration_date": 1641081600000.0  // milliseconds
        ]
        let buoObject = BranchUniversalObject()
        buoObject.addProperties(properties: buoData)
        
        XCTAssertEqual("testIdentifier", buoObject.canonicalIdentifier)
        XCTAssertEqual("testUrl", buoObject.canonicalUrl)
        XCTAssertEqual("testTitle", buoObject.title)
        XCTAssertEqual("testDescription", buoObject.contentDescription)
        XCTAssertEqual("testImageUrl", buoObject.imageUrl)
        XCTAssertEqual(["keyword1", "keyword2", "keyword3"], buoObject.keywords)
        XCTAssertTrue(buoObject.locallyIndex)
        XCTAssertFalse(buoObject.publiclyIndex)
        XCTAssertNotNil(buoObject.creationDate)
        XCTAssertNotNil(buoObject.expirationDate)
        
        expect.fulfill()
        wait(for: [expect], timeout: 1.0)
    }
    
    // MARK: - Branch Event Extensions Tests
    
    func testBranchEventPropertiesMapping() {
        let expect = expectation(description: "Test Event Properties Mapping")
        let testEvent = BranchEvent(name: "test_event")
        let eventProperties: [String: Any] = [
            "affiliation": "testAffiliation",
            "coupon": "testCoupon",
            "currency": "USD",
            "tax": "12.50",
            "revenue": 14.99,
            "shipping": "3.50",
            "description": "testDescription",
            "search_query": "testSearchQuery",
            "ad_type": "banner",
            "alias": "testAlias",
            "transaction_id": "txn_12345",
            "custom_data": ["key1": "value1", "key2": "value2"],
            "custom_property": "customValue"
        ]
        testEvent.addEventProperties(properties: eventProperties)
        
        XCTAssertEqual("testAffiliation", testEvent.affiliation)
        XCTAssertEqual("testCoupon", testEvent.coupon)
        XCTAssertEqual(BNCCurrency.USD, testEvent.currency)
        XCTAssertEqual(NSDecimalNumber(string: "12.50"), testEvent.tax)
        XCTAssertEqual(NSDecimalNumber(string: "14.99"), testEvent.revenue)
        XCTAssertEqual(NSDecimalNumber(string: "3.50"), testEvent.shipping)
        XCTAssertEqual("testDescription", testEvent.description)
        XCTAssertEqual("testSearchQuery", testEvent.searchQuery)
        XCTAssertEqual(BranchEventAdType.banner, testEvent.adType)
        XCTAssertEqual("testAlias", testEvent.alias)
        XCTAssertEqual("txn_12345", testEvent.transactionID)
        
        // Verify custom_data is properly mapped
        XCTAssertEqual("value1", testEvent.customData["key1"])
        XCTAssertEqual("value2", testEvent.customData["key2"])
        // Verify additional properties are added to customData
        XCTAssertEqual("customValue", testEvent.customData["custom_property"])
        
        expect.fulfill()
        wait(for: [expect], timeout: 1.0)
    }
    
    func testBranchEventAdTypeMapping() {
        let expect = expectation(description: "Test Ad Type Mapping")
        let testEvent = BranchEvent(name: "test_event")
        
        // Test all ad types
        let adTypes = [
            ("none", BranchEventAdType.none),
            ("banner", BranchEventAdType.banner),
            ("interstitial", BranchEventAdType.interstitial),
            ("rewarded_video", BranchEventAdType.rewardedVideo),
            ("native", BranchEventAdType.native),
            ("unknown_type", BranchEventAdType.none) // Should default to none
        ]
        
        for (inputType, expectedType) in adTypes {
            testEvent.addEventProperties(properties: ["ad_type": inputType])
            XCTAssertEqual(expectedType, testEvent.adType, "Failed for ad_type: \(inputType)")
        }
        
        expect.fulfill()
        wait(for: [expect], timeout: 1.0)
    }
    
    // MARK: - Branch Content Metadata Extensions Tests
    
    func testBranchContentMetadataPropertiesMapping() {
        let expect = expectation(description: "Test Content Metadata Mapping")
        let metadata: [String: Any] = [
            "quantity": 2.5,
            "price": "19.99",
            "currency_type": "EUR",
            "sku": "SKU123",
            "product_name": "Test Product",
            "product_brand": "Test Brand",
            "product_category": "Software",
            "condition": "NEW",
            "product_variant": "Premium",
            "rating": 4.5,
            "rating_average": "4.2",
            "rating_count": "150",
            "rating_max": 5.0,
            "address_street": "123 Test St",
            "address_city": "Test City",
            "address_region": "Test Region",
            "address_country": "Test Country",
            "address_postal_code": "12345",
            "latitude": 37.7749,
            "longitude": "-122.4194",
            "image_captions": ["Caption 1", "Caption 2"],
            "custom_metadata": ["custom_key": "custom_value"],
            "content_schema": "PRODUCT"
        ]
        
        let metadataObject = BranchContentMetadata()
        metadataObject.addMetadataProperties(metadata: metadata)
        
        XCTAssertEqual(2.5, metadataObject.quantity)
        XCTAssertEqual(NSDecimalNumber(string: "19.99"), metadataObject.price)
        XCTAssertEqual(BNCCurrency.EUR, metadataObject.currency)
        XCTAssertEqual("SKU123", metadataObject.sku)
        XCTAssertEqual("Test Product", metadataObject.productName)
        XCTAssertEqual("Test Brand", metadataObject.productBrand)
        XCTAssertEqual(BNCProductCategory.software, metadataObject.productCategory)
        XCTAssertEqual(BranchCondition.new, metadataObject.condition)
        XCTAssertEqual("Premium", metadataObject.productVariant)
        XCTAssertEqual(4.5, metadataObject.rating)
        XCTAssertEqual(4.2, metadataObject.ratingAverage)
        XCTAssertEqual(150, metadataObject.ratingCount)
        XCTAssertEqual(5.0, metadataObject.ratingMax)
        XCTAssertEqual("123 Test St", metadataObject.addressStreet)
        XCTAssertEqual("Test City", metadataObject.addressCity)
        XCTAssertEqual("Test Region", metadataObject.addressRegion)
        XCTAssertEqual("Test Country", metadataObject.addressCountry)
        XCTAssertEqual("12345", metadataObject.addressPostalCode)
        XCTAssertEqual(37.7749, metadataObject.latitude)
        XCTAssertEqual(-122.4194, metadataObject.longitude)
        XCTAssertEqual(["Caption 1", "Caption 2"], metadataObject.imageCaptions)
        XCTAssertEqual("custom_value", metadataObject.customMetadata["custom_key"] as? String)
        XCTAssertEqual(BranchContentSchema.product, metadataObject.contentSchema)
        
        expect.fulfill()
        wait(for: [expect], timeout: 1.0)
    }
    
    // MARK: - Type Checker Tests
    
    func testTypeCheckerWithDifferentTypes() {
        let expect = expectation(description: "Test TypeChecker Functionality")
        
        // Test Int conversion
        let intValue1: Int? = TypeChecker.getTypedPropertyForValue(value: 42)
        let intValue2: Int? = TypeChecker.getTypedPropertyForValue(value: "42")
        let intValue3: Int? = TypeChecker.getTypedPropertyForValue(value: "invalid")
        
        XCTAssertEqual(42, intValue1)
        XCTAssertEqual(42, intValue2)
        XCTAssertNil(intValue3)
        
        // Test Double conversion
        let doubleValue1: Double? = TypeChecker.getTypedPropertyForValue(value: 3.14)
        let doubleValue2: Double? = TypeChecker.getTypedPropertyForValue(value: "3.14")
        let doubleValue3: Double? = TypeChecker.getTypedPropertyForValue(value: "invalid")
        
        XCTAssertEqual(3.14, doubleValue1)
        XCTAssertEqual(3.14, doubleValue2)
        XCTAssertNil(doubleValue3)
        
        // Test String conversion
        let stringValue1: String? = TypeChecker.getTypedPropertyForValue(value: "test")
        let stringValue2: String? = TypeChecker.getTypedPropertyForValue(value: 123)
        
        XCTAssertEqual("test", stringValue1)
        XCTAssertNil(stringValue2)
        
        expect.fulfill()
        wait(for: [expect], timeout: 1.0)
    }
    
    // MARK: - String Extensions Tests
    
    func testStringCapitalizingFirstLetter() {
        let expect = expectation(description: "Test String Extension")
        
        XCTAssertEqual("Software", "software".capitalizingFirstLetter())
        XCTAssertEqual("Test", "TEST".capitalizingFirstLetter())
        XCTAssertEqual("Mixed_case", "mIXED_CASE".capitalizingFirstLetter())
        XCTAssertEqual("", "".capitalizingFirstLetter())
        
        expect.fulfill()
        wait(for: [expect], timeout: 1.0)
    }
}
