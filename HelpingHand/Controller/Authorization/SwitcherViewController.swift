//
//  SwitcherViewController.swift
//  HelpingHand
//
//  Created by Viktor Krasilnikov on 02.09.2018.
//  Copyright © 2018 Viktor Krasilnikov. All rights reserved.
//

import UIKit

class Switcher {
    
    // User stay logged in
    static func chooseRootViewController() {
        
        let loggedIn = UserDefaults.standard.bool(forKey: "Logged In")
        var rootViewController: UIViewController
        
        if loggedIn {
            rootViewController = UIStoryboard.init(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
        } else {
            rootViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuthNavigationViewController")
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootViewController
        
    }
}
