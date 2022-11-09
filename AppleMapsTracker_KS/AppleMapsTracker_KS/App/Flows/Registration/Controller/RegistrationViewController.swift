//
//  RegistrationViewController.swift
//  AppleMapsTracker_KS
//
//  Created by Константин Шмондрик on 09.11.2022.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    private var authView: RegistrationView {
        return self.view as! RegistrationView
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        let view = RegistrationView()
        view.delegate = self
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationItem.hidesBackButton = false
    }
    
    // MARK: - private func
    
    private func showError(_ errorMessage: String) {
        self.okAlert(title: "Ошибка", message: errorMessage, completionHandler: nil)
        
    }
    
    private func proceedToWelcomeScreen() {
        self.okAlert(title: "Поздравляем! Вы зарегестрированны.",
                     message: "Пройдите обратно и войдите в приложение при помощи вашего логина и пароля",
                     completionHandler: { _ in
            self.navigationController?.popViewController(animated: true)
        })
    }
    
}

extension RegistrationViewController: RegistViewProtocol {
    func tapRegistButton() {
        proceedToWelcomeScreen()
    }
}

