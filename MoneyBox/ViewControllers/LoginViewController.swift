//
//  LoginViewController.swift
//  MoneyBox
//
//  Created by shafique dassu on 13/01/2024.
//

import UIKit
import Networking
import Combine

class LoginViewController: UIViewController {
    
    private let viewModel: LoginViewModel
    
    var cancellables = Set<AnyCancellable>()
    
    lazy fileprivate var emailAddressTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "example@gmail.com"
        textField.layer.borderColor = UIColor.accentColor.cgColor
        textField.layer.borderWidth = 1.0
        textField.bind(with: viewModel.email, storeIn: &cancellables)
        return textField
    }()
    
    lazy fileprivate var emailAddressLabel: UILabel = {
       let emailLabel = UILabel()
        emailLabel.text = "Email address"
        emailLabel.textColor = UIColor.black
        return emailLabel
    }()
    
    lazy fileprivate var passwordLabel: UILabel = {
       let passwordLabel = UILabel()
        passwordLabel.text = "Password"
        passwordLabel.textColor = UIColor.black
        return passwordLabel
    }()
    
    lazy fileprivate var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = true
        textField.layer.borderColor = UIColor.accentColor.cgColor
        textField.layer.borderWidth = 1.0
        textField.bind(with: viewModel.password, storeIn: &cancellables)
        return textField
    }()
    
    lazy fileprivate var moneyBoxLogoImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "moneybox")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy fileprivate var logInButton: UIButton = {
       let button = RoundedButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor(named: "AccentColor")
        button.publishTap().sink { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.viewModel.login { result in
                switch result {
                case .success(let user):
                    DispatchQueue.main.async {
                        strongSelf.viewModel.appCoordinator.proceed(to: .userAccounts, data: user)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        strongSelf.presentError(title: error.errorTitle, message: error.errorMessage)
                    }
                }
            }
        }
        .store(in: &cancellables)
        return button
    }()
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Fatal error")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        setup()
    }
    private func setup() {
        view.backgroundColor = UIColor.white
    }
}

//MARK: - layout
extension LoginViewController {
    
    fileprivate func layout() {
        [logInButton, moneyBoxLogoImageView, emailAddressTextField, passwordTextField].forEach { uiView in
            view.addSubview(uiView)
        }

        NSLayoutConstraint.activate([
            moneyBoxLogoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            moneyBoxLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            moneyBoxLogoImageView.heightAnchor.constraint(equalToConstant: 50),
      
            emailAddressTextField.topAnchor.constraint(equalTo: moneyBoxLogoImageView.bottomAnchor, constant: 40),
            emailAddressTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            emailAddressTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            emailAddressTextField.heightAnchor.constraint(equalToConstant: 30),
            
            passwordTextField.topAnchor.constraint(equalTo: emailAddressTextField.bottomAnchor, constant: 5),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            passwordTextField.heightAnchor.constraint(equalToConstant: 30),
            
            logInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 25),
            logInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            logInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            logInButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
