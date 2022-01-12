//
//  MockBranchInstance.swift
//  TealiumBranchTests
//
//  Created by Tyler Rister on 10/20/21.
//

import Foundation
import Branch
@testable import TealiumBranch

class MockBranchInstance: BranchCommand {

    var initializeCount = 0
    var sendEventCount = 0
    var setIdentityCount = 0
    var setOptOutCount = 0
    var logoutCount = 0
    
    func initialize(payload: [String : Any]) {
        initializeCount += 1
    }
    
    func sendEvent(eventName: String, parameters: [String : Any]) {
        sendEventCount += 1
    }
    
    func sendEvent(event: BranchStandardEvent, parameters: [String : Any]) {
        sendEvent(eventName: event.rawValue, parameters: parameters)
    }
    
    func setIdentity(id: String) {
        setIdentityCount += 1
    }
    
    func setOptOut(opt: Bool) {
        setOptOutCount += 1
    }
    
    func logout() {
        logoutCount += 1
    }
    
}
