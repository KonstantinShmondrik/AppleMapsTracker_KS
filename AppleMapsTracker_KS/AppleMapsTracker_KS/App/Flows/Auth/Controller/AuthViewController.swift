//
//  AuthViewController.swift
//  AppleMapsTracker_KS
//
//  Created by Константин Шмондрик on 09.11.2022.
//

import UIKit
import RealmSwift

class AuthViewController: UIViewController {
    
    var onLogin: (() -> Void)?
    var onRegist: (() -> Void)?
    
    private var authView: AuthView {
        return self.view as! AuthView
    }
    
    let realm: Realm = try! Realm()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        let view = AuthView()
        view.delegate = self
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setToolbarHidden(true, animated: false)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - private func
    
    private func authenticated(login: String, password: String) -> Bool {
        let user = realm.object(ofType: User.self, forPrimaryKey: login)
        guard let user = user else { return false }
        if user.password == password {
            return true } else {
                return false
            }
    }
    
    private func showError(_ errorMessage: String) {
        self.okAlert(title: "Ошибка авторизации", message: errorMessage, completionHandler: nil)
    }
    
}

// MARK: - AuthViewProtocol
extension AuthViewController: AuthViewProtocol {
    
    func tapLoginButton(login: String, password: String) {
        
        guard login != "", password != "" else { return }
        
        print(login, password, authenticated(login: login, password: password))
        
        if authenticated(login: login, password: password) {
            UserDefaults.standard.set(true, forKey: "isLogin")
            onLogin?()
        } else {
            self.showError("Неверный логин или пароль")
        }
    }
    
    func tapRegistButton() {
        onRegist?()
    }
}
