//
//  AppDelegate.swift
//  TealiumBranchExample
//
//  Created by Tyler Rister on 10/18/21.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        TealiumHelper.start()
        return true
    }
}
