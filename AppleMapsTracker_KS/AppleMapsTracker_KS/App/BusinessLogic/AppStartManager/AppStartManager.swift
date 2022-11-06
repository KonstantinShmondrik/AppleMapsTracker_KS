//
//  AppStartManager.swift
//  AppleMapsTracker_KS
//
//  Created by Константин Шмондрик on 06.11.2022.
//

import UIKit

class StartManager {
    
    var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        let rootVC = ViewController()
        rootVC.navigationItem.title = "Карта"
        
        let navVC = self.configuredNavigationController
        navVC.viewControllers = [rootVC]
        
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
    }
    
    private lazy var configuredNavigationController: UINavigationController = {
        let navVC = UINavigationController()
        navVC.navigationBar.backgroundColor = .white
        navVC.navigationBar.barTintColor = .black
        navVC.navigationBar.isTranslucent = true
        navVC.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navVC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        return navVC
    }()
    
    
}

