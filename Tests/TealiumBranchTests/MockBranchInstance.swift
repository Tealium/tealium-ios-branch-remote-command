//
//  MockBranchInstance.swift
//  TealiumBranchTests
//
//  Created by Tyler Rister on 10/20/21.
//

import BranchSDK
import UIKit

@testable import TealiumBranch

class MockBranchInstance: BranchCommand {

    var processRemoteCommandCount = 0
    var initializeCount = 0
    var sendEventCount = 0
    var setIdentityCount = 0
    var setOptOutCount = 0
    var logoutCount = 0
    var onReadyCallCount = 0

    func onReady(_ onReady: @escaping () -> Void) {
        onReadyCallCount += 1
        // Simulate immediate ready state for testing
        onReady()
    }

    func initialize(
        payload: [String: Any],
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) {
        initializeCount += 1
    }

    func sendEvent(eventName: String, parameters: [String: Any]) {
        sendEventCount += 1
        processRemoteCommandCount += 1
    }

    func sendEvent(event: BranchStandardEvent, parameters: [String: Any]) {
        sendEvent(eventName: event.rawValue, parameters: parameters)
    }

    func setIdentity(id: String) {
        setIdentityCount += 1
        processRemoteCommandCount += 1
    }

    func setOptOut(opt: Bool) {
        setOptOutCount += 1
        processRemoteCommandCount += 1
    }

    func logout() {
        logoutCount += 1
        processRemoteCommandCount += 1
    }

}
