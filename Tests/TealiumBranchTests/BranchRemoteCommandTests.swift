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

    func testProcessRemoteCommandNotRunIfNoCommandName() {
        let payload: [String: Any] = [:]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, branchInstance.processRemoteCommandCount)
    }

    func testOnReady() {
        branchCommand.onReady { }  
        XCTAssertEqual(1, branchInstance.onReadyCallCount)
    }

    func testOnReadyCalledAfterInitialize() {
        let onReadyIsCalled = expectation(description: "onReady is called")
        let command = BranchRemoteCommand(branchInstance: BranchInstance())
        command.onReady {
            onReadyIsCalled.fulfill()
        }
        command.processRemoteCommand(with: ["command_name": "initialize"])
        waitForExpectations(timeout: 3.0)
    }
 
    func testInitialize() {
        let payload: [String: Any] = ["command_name": "initialize"]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.initializeCount)
    }

    func testSetIdentity() {
        let payload: [String: Any] = [
            "command_name": "setuserid", "user_id": "testUserId"
        ]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.setIdentityCount)
    }

    func testSetIdentityWithNoUserId() {
        let payload: [String: Any] = [
            "command_name": "setuserid"
        ]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, branchInstance.setIdentityCount)
    }
    
    func testLogout() {
        let payload: [String: Any] = [
            "command_name": "logout"
        ]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.logoutCount)
    }
    
    func testSendEventWithBuoData() {
        let buoData: [String: Any] = [
            "canonical_identifier": "testIdentifier",
            "canonical_url": "testUrl",
            "title": "testTitle",
            "description": "testDescription",
            "image_url": "testImageUrl"
        ]
        let payload: [String: Any] = [
            "command_name": "addtocart",
            "buo": buoData
        ]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.sendEventCount)
    }
    
    func testSendEventWithCustomEventName() {
        let payload: [String: Any] = ["command_name": "sendevent", "event_name": "testEvent"]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.sendEventCount)
    }
}
