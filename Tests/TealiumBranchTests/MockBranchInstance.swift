//
//  MockBranchInstance.swift
//  TealiumBranchTests
//
//  Created by Tyler Rister on 10/20/21.
//

import Foundation
import BranchSDK
@testable import TealiumBranch

class MockBranchInstance: BranchCommand {

    var initializeCount = 0
    var sendEventCount = 0
    var setIdentityCount = 0
    var setOptOutCount = 0
    var logoutCount = 0
    var onReadyCallCount = 0
    var getBranchSDKInstanceCallCount = 0
    
    private var onReadyCallbacks: [() -> Void] = []
    
    func onReady(_ onReady: @escaping () -> Void) {
        onReadyCallCount += 1
        onReadyCallbacks.append(onReady)
        onReady() // Immediately call for testing
    }
    
    func initialize(payload: [String: Any], launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        initializeCount += 1
        // Trigger onReady callbacks after initialization
        for callback in onReadyCallbacks {
            callback()
        }
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
    
    func getBranchSDKInstance() -> Branch {
        getBranchSDKInstanceCallCount += 1
        return Branch.getInstance()
    }
    
}
