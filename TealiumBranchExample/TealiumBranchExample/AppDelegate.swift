//
//  AppDelegate.swift
//  TealiumBranchExample
//
//  Created by Tyler Rister on 10/18/21.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        TealiumHelper.shared.configure(with: launchOptions)
        return true
    }
    
    // MARK: - URL Scheme Handling
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Track deep link through Tealium -> Branch Remote Command
        let deepLinkData: [String: Any] = [ 
            "deep_link_url": url.absoluteString
        ]
        TealiumHelper.trackEvent(title: "handle_deep_link", data: deepLinkData)
        print("🔗 URL Scheme Deep Link: \(url.absoluteString)")
        return true
    }
    
    // MARK: - Universal Links Handling
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        // Handle Universal Links through Tealium -> Branch Remote Command
        if let url = userActivity.webpageURL {
            let deepLinkData: [String: Any] = [
                "command_name": "handle_deep_link",
                "deep_link_url": url.absoluteString
            ]
            TealiumHelper.trackEvent(title: "deep_link_received", data: deepLinkData)
            print("🔗 Universal Link: \(url.absoluteString)")
        }
        return true
    }
    
    // MARK: - Push Notifications
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Handle Branch push notifications through Tealium
        let pushData: [String: Any] = [
            "push_notification_user_info": userInfo
        ]
        TealiumHelper.trackEvent(title: "handle_push_notification", data: pushData)
        print("📱 Push Notification: \(userInfo)")
        completionHandler(.newData)
    }
}
