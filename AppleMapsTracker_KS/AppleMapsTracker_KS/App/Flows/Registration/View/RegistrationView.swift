//
//  RegistrationView.swift
//  AppleMapsTracker_KS
//
//  Created by Константин Шмондрик on 09.11.2022.
//

import UIKit


protocol RegistViewProtocol: AnyObject {
    func tapRegistButton(login: String, password: String)
}

class RegistrationView: UIView {
    
    // MARK: - Subviews
    private(set) lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 2000)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = false
        
        return scrollView
    }()
    
    private(set) lazy var hederLabel: UILabel = {
        let label = UILabel()
        label.text = "Регистрация пользователя"
        label.numberOfLines = 1
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private(set) lazy var loginTexField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .bezel
        textField.attributedPlaceholder = NSAttributedString(string: "Введите логин", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.textColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private(set) lazy var passwordTexField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .bezel
        textField.attributedPlaceholder = NSAttributedString(string: "Введите пароль", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.textColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private(set) lazy var passwordAgainTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .bezel
        textField.attributedPlaceholder = NSAttributedString(string: "Введите пароль повторно", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.textColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private(set) lazy var registButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .blue
        button.tintColor = .white
        button.setTitle("Зарегестрироваться", for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 16.0
        button.addTarget(self, action: #selector(registButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private(set) lazy var cleanAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .blue
        button.tintColor = .white
        button.layer.cornerRadius = 16.0
        button.setTitle("Очистить форму", for: .normal)
        button.addTarget(self, action: #selector(cleanAllButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: - Properties
    weak var delegate: RegistViewProtocol?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
        self.setupControls()
        self.registerNotifications()
        self.hideKeyboardGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func configureUI() {
        self.backgroundColor = .white
        self.addSubview(self.scrollView)
        
        [self.hederLabel,
         self.loginTexField,
         self.passwordTexField,
         self.passwordAgainTextField,
         self.registButton,
         self.cleanAllButton
        ].forEach {
            self.scrollView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0.0),
            self.scrollView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor,constant: 0.0),
            self.scrollView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor,constant: 0.0),
            self.scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor,constant: 0.0),
            
            self.hederLabel.topAnchor.constraint(lessThanOrEqualTo: self.scrollView.topAnchor, constant: 20),
            self.hederLabel.heightAnchor.constraint(equalToConstant: 30.0),
            self.hederLabel.widthAnchor.constraint(equalToConstant: 400.0),
            self.hederLabel.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor),
            
            self.loginTexField.topAnchor.constraint(equalTo: self.hederLabel.bottomAnchor, constant: 10.0),
            self.loginTexField.heightAnchor.constraint(equalToConstant: 50.0),
            self.loginTexField.widthAnchor.constraint(equalToConstant: 350.0),
            self.loginTexField.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor),
            
            self.passwordTexField.topAnchor.constraint(equalTo: self.loginTexField.bottomAnchor, constant: 10.0),
            self.passwordTexField.heightAnchor.constraint(equalToConstant: 50.0),
            self.passwordTexField.widthAnchor.constraint(equalToConstant: 350.0),
            self.passwordTexField.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor),
            
            self.passwordAgainTextField.topAnchor.constraint(equalTo: self.passwordTexField.bottomAnchor, constant: 10.0),
            self.passwordAgainTextField.heightAnchor.constraint(equalToConstant: 50.0),
            self.passwordAgainTextField.widthAnchor.constraint(equalToConstant: 350.0),
            self.passwordAgainTextField.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor),
            
            self.registButton.topAnchor.constraint(equalTo: self.passwordAgainTextField.bottomAnchor, constant: 30.0),
            self.registButton.heightAnchor.constraint(equalToConstant: 50.0),
            self.registButton.widthAnchor.constraint(equalToConstant: 250.0),
            self.registButton.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor),
            
            self.cleanAllButton.topAnchor.constraint(equalTo: self.registButton.bottomAnchor, constant: 20.0),
            self.cleanAllButton.heightAnchor.constraint(equalToConstant: 50.0),
            self.cleanAllButton.widthAnchor.constraint(equalToConstant: 250.0),
            self.cleanAllButton.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor),
        ])
    }
    
    // MARK: - private func
    
    private func setupControls() {
        registButton.backgroundColor = UIColor.opaqueSeparator
        registButton.isEnabled = false
        
        [loginTexField, passwordTexField].forEach {
            $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        }
    }
    
    private func isFormFilled() -> Bool {
        guard loginTexField.text != "",
              passwordTexField.text != "" else {
            return false
        }
        return true
    }
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func hideKeyboardGesture() {
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        scrollView.addGestureRecognizer(hideKeyboardGesture)
    }
    
    // MARK: - Actions
    
    @objc private func registButtonPressed() {
        let login = loginTexField.text ?? ""
        let password = passwordTexField.text ?? ""
        let passAgain = passwordAgainTextField.text ?? ""
        
        guard login != "", password != "", passAgain != "" else { return }
        guard password == passAgain else { return }

        delegate?.tapRegistButton(login: login, password: password)
    }
    
    @objc private func cleanAllButtonPressed() {
        loginTexField.text = ""
        passwordTexField.text = ""
        passwordAgainTextField.text = ""
        
        setupControls()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        
        var keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        var contentInset: UIEdgeInsets = self.scrollView.contentInset
        
        keyboardFrame = self.scrollView.convert(keyboardFrame, from: nil)
        
        contentInset.bottom = keyboardFrame.size.height + 50
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    @objc func hideKeyboard() {
        self.scrollView.endEditing(true)
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        guard isFormFilled() else {
            registButton.backgroundColor = UIColor.opaqueSeparator
            registButton.isEnabled = false
            return
        }
        registButton.backgroundColor = .blue
        registButton.isEnabled = true
    }
    
}
