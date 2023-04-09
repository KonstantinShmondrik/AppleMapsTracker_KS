//
//  ApplicationCoordinator.swift
//  AppleMapsTracker_KS
//
//  Created by Константин Шмондрик on 09.11.2022.
//

import UIKit

final class ApplicationCoordinator: BaseCoordinator {
    
    override func start() {
        if UserDefaults.standard.bool(forKey: "isLogin") {
            toMap()
        } else {
            toAuth()
        }
    }
    
    private func toMap() {
        let coordinator = MapSceneCoordinator()
        coordinator.onFinishFlow = { [weak self, weak coordinator] in
            guard let self = self else { return }
            
            self.removeDependency(coordinator)
            self.start()
        }
        addDependency(coordinator)
        coordinator.start()
    }
    
    private func toAuth() {
        let coordinator = AuthCoordinator()
        coordinator.onFinishFlow = { [weak self, weak coordinator] in
            guard let self = self else { return }
            
            self.removeDependency(coordinator)
            self.start()
        }
        addDependency(coordinator)
        coordinator.start()
    }
}
