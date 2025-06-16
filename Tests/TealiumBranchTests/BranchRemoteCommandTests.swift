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
        let payload: [String: Any] = ["command_name": "initialize"]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.initializeCount)
    }
    
    func testStandardEventWithBuoData() {
        let buoData: [String: Any] = [
            "canonical_identifier": "testIdentifier",
            "canonical_url": "testUrl",
            "title": "testTitle",
            "description": "testDescription",
            "image_url": "testImageUrl"
        ]
        let payload: [String: Any] = ["command_name": "addtocart", "buo": buoData]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.sendEventCount)
    }
    
    func testSetIdentity() {
        let payload: [String: Any] = [
            "command_name": "setuserid", "user_id": "testUserId"
        ]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.setIdentityCount)
    }
    
    func testLogout() {
        let payload: [String: Any] = [
            "command_name": "logout"
        ]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.logoutCount)
    }
    
}
