//
//  BranchRemoteCommandTests.swift
//  TealiumBranchTests
//
//  Created by Tyler Rister on 10/20/21.
//

import XCTest
@testable import TealiumBranch
import TealiumRemoteCommands

class BranchRemoteCommandTests: XCTestCase {

    let branchInstance = MockBranchInstance()
    var branchCommand: BranchRemoteCommand!

    override func setUp() {
        branchCommand = BranchRemoteCommand(branchInstance: branchInstance)
    }

    override func tearDown() {
    }
 
    func testInitialize() {
        let expect = expectation(description: "Test Initialize")
        let payload: [String: Any] = ["command_name": "initialize"]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "branch", payload: payload) {
            branchCommand.completion(response)
            XCTAssertEqual(1, branchInstance.initializeCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 5.0)
    }
    
    func testStandardEventWithBuoData() {
        let expect = expectation(description: "Test Standard Event with Buo Data")
        let buoData: [String: Any] = [
            "canonical_identifier": "testIdentifier",
            "canonical_url": "testUrl",
            "title": "testTitle",
            "description": "testDescription",
            "image_url": "testImageUrl"
        ]
        let payload: [String: Any] = ["command_name": "addtocart", "buo": buoData]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "branch", payload: payload) {
            branchCommand.completion(response)
            XCTAssertEqual(1, branchInstance.sendEventCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 5.0)
    }
    
    func testSetIdentity() {
        let expect = expectation(description: "Test Set Identity")
        let payload: [String: Any] = [
            "command_name": "setuserid", "user_id": "testUserId"
        ]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "branch", payload: payload) {
            branchCommand.completion(response)
            XCTAssertEqual(1, branchInstance.setIdentityCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 5.0)
    }
    
    func testLogout() {
        let expect = expectation(description: "Test Logout")
        let payload: [String: Any] = [
            "command_name": "logout"
        ]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "branch", payload: payload) {
            branchCommand.completion(response)
            XCTAssertEqual(1, branchInstance.logoutCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 5.0)
    }
    
}
