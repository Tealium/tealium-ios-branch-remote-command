//
//  BranchInstanceTests.swift
//  TealiumBranchTests
//
//  Created by Tyler Rister on 10/20/21.
//

import XCTest
@testable import TealiumBranch
import TealiumRemoteCommands
import Branch

class BranchInstanceTests: XCTestCase {

    let branchInstance = MockBranchInstance()
    var branchCommand: BranchRemoteCommand!

    override func setUp() {
        branchCommand = BranchRemoteCommand(branchInstance: branchInstance)
    }

    override func tearDown() {
    }
    
    func testBuo() {
        let expect = expectation(description: "Test Standard Event with Buo Data")
        let buoData: [String: Any] = [
            "canonical_identifier": "testIdentifier",
            "canonical_url": "testUrl",
            "title": "testTitle",
            "description": "testDescription",
            "image_url": "testImageUrl"
        ]
        let buoObject = BranchUniversalObject()
        buoObject.addProperties(properties: buoData)
        XCTAssertEqual("testIdentifier", buoObject.canonicalIdentifier)
        XCTAssertEqual("testUrl", buoObject.canonicalUrl)
        XCTAssertEqual("testTitle", buoObject.title)
        XCTAssertEqual("testDescription", buoObject.contentDescription)
        XCTAssertEqual("testImageUrl", buoObject.imageUrl)
        expect.fulfill()
        wait(for: [expect], timeout: 5.0)
    }
    
    func testEventProperties() {
        let expect = expectation(description: "Test Event Properties")
        let testEvent = BranchEvent(name: "test_event")
        let eventProperties: [String: Any] = [
            "affiliation": "testAffiliation",
            "coupon": "testCoupon",
            "currency": "USD",
            "tax": "12.00",
            "revenue": 14.00,
            "description": "testDescription",
            "search_query": "testSearchQuery",
            "custom_data_key_1": "testCustomDataKey1",
            "custom_data_key_2": "testCustomDataKey2"
        ]
        testEvent.addEventProperties(properties: eventProperties)
        XCTAssertEqual("testAffiliation", testEvent.affiliation)
        XCTAssertEqual("testCoupon", testEvent.coupon)
        XCTAssertEqual(BNCCurrency.USD, testEvent.currency)
        XCTAssertEqual(NSDecimalNumber(string: "12.00"), testEvent.tax)
        XCTAssertEqual(NSDecimalNumber(string: "14.00"), testEvent.revenue)
        XCTAssertEqual("testDescription", testEvent.eventDescription)
        XCTAssertEqual("testSearchQuery", testEvent.searchQuery)
        XCTAssertEqual("testCustomDataKey1", testEvent.customData["custom_data_key_1"])
        XCTAssertEqual("testCustomDataKey2", testEvent.customData["custom_data_key_2"])
        expect.fulfill()
        wait(for: [expect], timeout: 5.0)
    }
    
    func testMetadata() {
        let expect = expectation(description: "Test Event Metadata")
        let metadata: [String: Any] = [
            "quantity": 1.00,
            "sku": "testSku",
            "product_name": "testProductName",
            "product_brand": "testProductBrand",
            "product_category": "Software",
            "condition": "good",
            "product_variant": "testProductVariant",
            "rating": 3.00,
            "rating_average": "4.00",
            "rating_count": "5",
            "rating_max": 6.00,
            "address_street": "testAddressStreet",
            "address_city": "testAddressCity",
            "address_region": "testAddressRegion",
            "address_country": "testAddressCountry",
            "address_postal_code": "testAddressPostalCode",
            "latitude": 7.0,
            "longitude": "8.0",
            "image_captions": ["testCaption1", "testCaption2", "testCaption3"]
        ]
        let metaDataObject = BranchContentMetadata()
        metaDataObject.addMetadataProperties(metadata: metadata)
        XCTAssertEqual(1.0, metaDataObject.quantity)
        XCTAssertEqual("testSku", metaDataObject.sku)
        XCTAssertEqual("testProductName", metaDataObject.productName)
        XCTAssertEqual("testProductBrand", metaDataObject.productBrand)
        XCTAssertEqual(BNCProductCategory.software, metaDataObject.productCategory)
        XCTAssertEqual(BranchCondition.good, metaDataObject.condition)
        XCTAssertEqual("testProductVariant", metaDataObject.productVariant)
        XCTAssertEqual(3.00, metaDataObject.rating)
        XCTAssertEqual(4.00, metaDataObject.ratingAverage)
        XCTAssertEqual(5, metaDataObject.ratingCount)
        XCTAssertEqual(6.00, metaDataObject.ratingMax)
        XCTAssertEqual("testAddressStreet", metaDataObject.addressStreet)
        XCTAssertEqual("testAddressCity", metaDataObject.addressCity)
        XCTAssertEqual("testAddressRegion", metaDataObject.addressRegion)
        XCTAssertEqual("testAddressCountry", metaDataObject.addressCountry)
        XCTAssertEqual("testAddressPostalCode", metaDataObject.addressPostalCode)
        XCTAssertEqual(7.0, metaDataObject.latitude)
        XCTAssertEqual(8.0, metaDataObject.longitude)
        XCTAssertEqual(["testCaption1", "testCaption2", "testCaption3"], metaDataObject.imageCaptions)
        expect.fulfill()
        wait(for: [expect], timeout: 5.0)
    }
}
