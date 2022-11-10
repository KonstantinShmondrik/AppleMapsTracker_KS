//
//  RegistrationViewController.swift
//  AppleMapsTracker_KS
//
//  Created by Константин Шмондрик on 09.11.2022.
//

import UIKit
import RealmSwift

class RegistrationViewController: UIViewController {
    
    var onRegist: (() -> Void)?
    
    private var authView: RegistrationView {
        return self.view as! RegistrationView
    }
    
    let realm: Realm = try! Realm()
    
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
    
    private func writeToDB(user: User) {
        try! realm.write {
            realm.add(user)
        }
    }
    
    private func showError(_ errorMessage: String) {
        self.okAlert(title: "Ошибка", message: errorMessage, completionHandler: nil)
        
    }
    
    private func proceedToWelcomeScreen() {
        self.okAlert(title: "Поздравляем! Вы зарегестрированны.",
                     message: "Пройдите обратно и войдите в приложение при помощи вашего логина и пароля",
                     completionHandler: { _ in
            self.onRegist?()
            self.navigationController?.popViewController(animated: true)
        })
    }
    
}

extension RegistrationViewController: RegistViewProtocol {
    func tapRegistButton(login: String, password: String) {
        let user = User()
        
        user.login = login
        user.password = password
        
        let userDB = realm.object(ofType: User.self, forPrimaryKey: login)
        if userDB?.login == login {
            self.yesNoAlert(title: "Пользователь уже существует", message: "Хотите сменить пароль?") { _ in
                try! self.realm.write {
                    userDB?.password = password
                    self.proceedToWelcomeScreen()
                }
            }
        } else {
            writeToDB(user: user)
            proceedToWelcomeScreen()
        }
    }
}

