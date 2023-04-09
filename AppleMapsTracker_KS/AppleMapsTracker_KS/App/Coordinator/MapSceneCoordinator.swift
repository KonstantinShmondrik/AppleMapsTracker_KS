//
//  MainCoordinator.swift
//  AppleMapsTracker_KS
//
//  Created by Константин Шмондрик on 09.11.2022.
//

import UIKit

final class MapSceneCoordinator: BaseCoordinator {
    var rootController: UINavigationController?
    var onFinishFlow: (() -> Void)?
    
    override func start() {
        showMapModule()
    }

    private func showMapModule() {
        let controller = MapsSceneViewController()
       
        controller.onLogOut = { [weak self] in
            guard let self = self else { return }
            
            self.onFinishFlow?()
        }

        let rootController = UINavigationController(rootViewController: controller)
        setAsRoot(rootController)
        self.rootController = rootController
    }
}
