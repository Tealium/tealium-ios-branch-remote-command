//
//  BranchRemoteCommand.swift
//  TealiumBranch
//
//  Created by Tyler Rister on 10/18/21.
//

import BranchSDK
import Foundation

#if COCOAPODS
    import TealiumSwift
#else
    import TealiumCore
    import TealiumRemoteCommands
#endif

public class BranchRemoteCommand: RemoteCommand {

    let branchInstance: BranchCommand
    private let launchOptions: [UIApplication.LaunchOptionsKey: Any]?

    override public var version: String? {
        return BranchConstants.version
    }

    public init(
        type: RemoteCommandType = .webview,
        branchInstance: BranchCommand = BranchInstance(),
        launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) {
        self.branchInstance = branchInstance
        self.launchOptions = launchOptions
        weak var weakSelf: BranchRemoteCommand?
        super.init(
            commandId: BranchConstants.commandId,
            description: BranchConstants.description,
            type: type,
            completion: { response in
                guard let payload = response.payload else {
                    return
                }
                weakSelf?.processRemoteCommand(with: payload)
            }
        )
        weakSelf = self
    }

    public func onReady(_ onReady: @escaping () -> Void) {
        self.branchInstance.onReady(onReady)
    }

    func processRemoteCommand(with payload: [String: Any]) {
        guard let command = payload[BranchConstants.commandName] as? String
        else {
            return
        }
        let commands = command.split(separator: BranchConstants.seperator)
        let branchCommands = commands.map {
            $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        branchCommands.forEach { command in
            switch command {
            case BranchConstants.Commands.initialize:
                branchInstance.initialize(
                    payload: payload,
                    launchOptions: self.launchOptions
                )
            case BranchConstants.Commands.setUserId:
                guard
                    let id = payload[BranchConstants.EventKeys.userId]
                        as? String
                else {
                    break
                }
                branchInstance.setIdentity(id: id)
            case BranchConstants.Commands.logout:
                branchInstance.logout()
            default:
                if let standardEvent = Self.eventsMap[command] {
                    branchInstance.sendEvent(
                        event: standardEvent,
                        parameters: payload
                    )
                } else {
                    branchInstance.sendEvent(
                        eventName: command,
                        parameters: payload
                    )
                }
            }
        }
    }
}

extension BranchRemoteCommand {
    static let eventsMap: [String: BranchStandardEvent] = [
        "achievelevel": BranchStandardEvent.achieveLevel,
        "addpaymentinfo": BranchStandardEvent.addPaymentInfo,
        "addtocart": BranchStandardEvent.addToCart,
        "addtowishlist": BranchStandardEvent.addToWishlist,
        "clickad": BranchStandardEvent.clickAd,
        "completeregistration": BranchStandardEvent.completeRegistration,
        "completestream": BranchStandardEvent.completeStream,
        "completetutorial": BranchStandardEvent.completeTutorial,
        "initiatepurchase": BranchStandardEvent.initiatePurchase,
        "initiatestream": BranchStandardEvent.initiateStream,
        "invite": BranchStandardEvent.invite,
        "login": BranchStandardEvent.login,
        "purchase": BranchStandardEvent.purchase,
        "rate": BranchStandardEvent.rate,
        "reserve": BranchStandardEvent.reserve,
        "search": BranchStandardEvent.search,
        "share": BranchStandardEvent.share,
        "spendcredits": BranchStandardEvent.spendCredits,
        "starttrial": BranchStandardEvent.startTrial,
        "subscribe": BranchStandardEvent.subscribe,
        "unlockachievement": BranchStandardEvent.unlockAchievement,
        "viewad": BranchStandardEvent.viewAd,
        "viewcart": BranchStandardEvent.viewCart,
        "viewitem": BranchStandardEvent.viewItem,
        "viewitems": BranchStandardEvent.viewItems,
    ]
}
