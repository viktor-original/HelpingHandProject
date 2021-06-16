//
//  MainTabBarViewController.swift
//  HelpingHand
//
//  Created by Viktor Krasilnikov on 29.08.2018.
//  Copyright © 2018 Viktor Krasilnikov. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let viewControllers = self.viewControllers else { return }
        
        if viewControllers.count > 1 {
            self.selectedIndex = 1;
        }
        
        self.tabBar.barTintColor = UIColor.clear
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.tintColor = UIColor.red
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)], for: .normal)
        
        let tabBarItemsLabels = [NSLocalizedString(Constants.PROFILE, comment: ""),
                                 NSLocalizedString(Constants.ROLE, comment: "")]
        
        for i in stride(from: 0, to: self.tabBar.items!.count - 1, by: 1) {
            if let tabItem = self.tabBar.items?[i] as UITabBarItem? {
                tabItem.title = tabBarItemsLabels[i]
            }
        }
    }
}
