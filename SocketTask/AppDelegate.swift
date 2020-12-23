//
//  AppDelegate.swift
//  SocketTask
//
//  Created by Ismael AlShabrawy on 20/12/2020.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.enable = true

        let userDefaults = UserDefaults.standard

        if userDefaults.bool(forKey: "hasRunBefore") == false {
             // Remove Keychain items here
            KeychainWrapper.standard.removeObject(forKey: "User")
             // Update the flag indicator
             userDefaults.set(true, forKey: "hasRunBefore")
             userDefaults.synchronize() // Forces the app to update UserDefaults
        }

        
        if (UIApplication.converToUserLoginModel() != nil) {
            SocketHelper.shared.establishConnection()
            self.window = ControllerProvider.setMainWindow(className: ChatsNavigationVC.self, storyBoard: .chatStoryBoard)
        } else {
            SocketHelper.shared.closeConnection()
            self.window = ControllerProvider.setMainWindow(className: LoginVC.self, storyBoard: .homeStoryBoard)
        }
        
        UIView.animate(withDuration: 0.25) {
            self.window?.makeKeyAndVisible()
        }
        return true
    }
    
    
}

