//
//  BranchRemoteCommand.swift
//  TealiumBranch
//
//  Created by Tyler Rister on 10/18/21.
//

import Foundation
import Branch
#if COCOAPODS
    import TealiumSwift
#else
    import TealiumCore
    import TealiumTagManagement
    import TealiumRemoteCommands
#endif

public class BranchRemoteCommand: RemoteCommand {
    
    var branchInstance: BranchCommand
    
    public init(branchInstance: BranchCommand = BranchInstance(), type: RemoteCommandType = .webview) {
        self.branchInstance = branchInstance
        weak var weakSelf: BranchRemoteCommand?
        super.init(commandId: BranchConstants.commandId, description: BranchConstants.description, type: type, completion: { response in
            guard let payload = response.payload else {
                return
            }
            weakSelf?.processRemoteCommand(with: payload)
        })
        weakSelf = self
    }
    
    func processRemoteCommand(with payload: [String: Any]) {
        guard let command = payload[BranchConstants.commandName] as? String else {
            return
        }
        let commands = command.split(separator: BranchConstants.seperator)
        let branchCommands = commands.map { $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) }
        branchCommands.forEach { command in
            switch (command) {
            case BranchConstants.Commands.initialize:
                branchInstance.initialize(payload: payload)
            case BranchConstants.Commands.setUserId:
                guard let id = payload[BranchConstants.EventKeys.userId] as? String else {
                    break
                }
                branchInstance.setIdentity(id: id)
            case BranchConstants.Commands.logout:
                branchInstance.logout()
            default:
                if let standardEvent = BranchStandardEvent.eventFromEventName(eventName: command) {
                    branchInstance.sendEvent(event: standardEvent, parameters: payload)
                } else {
                    branchInstance.sendEvent(eventName: command, parameters: payload)
                }
            }
        }
    }
}

extension BranchStandardEvent {
    static func eventFromEventName(eventName: String) -> BranchStandardEvent? {
        if let branchEvent = BranchConstants.StandardEventNames(rawValue: eventName) {
            switch (branchEvent) {
            case .achievelevel:
                return BranchStandardEvent.achieveLevel
            case .addpaymentinfo:
                return BranchStandardEvent.addPaymentInfo
            case .addtocart:
                return BranchStandardEvent.addToCart
            case .addtowishlist:
                return BranchStandardEvent.addToWishlist
            case .clickad:
                return BranchStandardEvent.clickAd
            case .completetutorial:
                return BranchStandardEvent.completeTutorial
            case .completeregistration:
                return BranchStandardEvent.completeRegistration
            case .initiatepurchase:
                return BranchStandardEvent.initiatePurchase
            case .invite:
                return BranchStandardEvent.invite
            case .login:
                return BranchStandardEvent.login
            case .purchase:
                return BranchStandardEvent.purchase
            case .rate:
                return BranchStandardEvent.rate
            case .reserve:
                return BranchStandardEvent.reserve
            case .search:
                return BranchStandardEvent.search
            case .share:
                return BranchStandardEvent.share
            case .spendcredits:
                return BranchStandardEvent.spendCredits
            case .starttrial:
                return BranchStandardEvent.startTrial
            case .subscribe:
                return BranchStandardEvent.subscribe
            case .unlockachievement:
                return BranchStandardEvent.unlockAchievement
            case .viewad:
                return BranchStandardEvent.viewAd
            case .viewcart:
                return BranchStandardEvent.viewCart
            case .viewitem:
                return BranchStandardEvent.viewItem
            case .viewitems:
                return BranchStandardEvent.viewItems
            }
        } else {
            return nil
        }
    }
}
