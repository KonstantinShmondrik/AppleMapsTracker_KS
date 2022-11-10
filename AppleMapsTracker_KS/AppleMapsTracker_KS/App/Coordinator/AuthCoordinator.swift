//
//  AuthCoordinator.swift
//  AppleMapsTracker_KS
//
//  Created by Константин Шмондрик on 09.11.2022.
//

import UIKit

final class AuthCoordinator: BaseCoordinator {
    var rootController: UINavigationController?
    var onFinishFlow: (() -> Void)?
    
    override func start() {
        showLoginModule()
    }
    
    private func showLoginModule() {
        let controller = AuthViewController()

        controller.onRegist = { [weak self] in
            self?.showRrgistModule()
        }
        
        controller.onLogin = { [weak self] in
            self?.onFinishFlow?()
        }
        let rootController = UINavigationController(rootViewController: controller)
        setAsRoot(rootController)
        self.rootController = rootController
    }
    
    private func showRrgistModule() {
        let controller = RegistrationViewController()
        rootController?.pushViewController(controller, animated: true)
    }
    
}

