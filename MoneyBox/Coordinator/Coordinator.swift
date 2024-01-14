//
//  Coordinator.swift
//  MoneyBox
//
//  Created by shafique dassu on 14/01/2024.
//

import Foundation
import UIKit
import Networking

class AppCoordinator: NSObject {

    private var window: UIWindow?
    private var navigationController: UINavigationController?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    enum Destination {
        case login, userAccounts, userAccountDetail
    }
    
    func start() {
        let loginViewModel = LoginViewModel(appCoordinator: self)
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        //loginViewController.viewModel.appCoordinator = self
        window!.rootViewController = loginViewController
        window!.makeKeyAndVisible()
    }
    
    private func goToUserAccounts(loginResponse: LoginResponse.User) {
        print("going to user accounts")
        let userAccountsViewModel = UserAccountsViewModel(loginResponse: loginResponse)
        userAccountsViewModel.appCoordinator = self
        let userAccountsViewController = UserAccountsViewController(viewModel: userAccountsViewModel)
        let userAccountsNavigationController = UINavigationController(rootViewController: userAccountsViewController)
        navigationController = userAccountsNavigationController
        if window != nil {
            print("window is valid")
        } else {
            print("window is invalid")
        }
        window?.rootViewController = userAccountsNavigationController
    }
    
    private func goToLogin() {
        let loginViewModel = LoginViewModel(appCoordinator: self)
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        //loginViewController.viewModel.appCoordinator = self
        window?.rootViewController = loginViewController
    }
    
    private func goToUserAccountDetail(productResponse: ProductResponse) {
        let userAccountDetailViewModel = UserAccountsDetailViewModel(productResponse: productResponse)
        let userAccountDetailViewController = UserAccountDetailViewController(viewModel: userAccountDetailViewModel)
        navigationController?.pushViewController(userAccountDetailViewController, animated: true)
    }
    
    func proceed(to destination: Destination, data: Any?) {
        switch destination {
        case .login:
            goToLogin()
        case .userAccounts:
            print("should show user accounts")
            if let loginResponseUser = data as? LoginResponse.User {
                goToUserAccounts(loginResponse: loginResponseUser)
            }
        case .userAccountDetail:
            if let productResponse = data as? ProductResponse {
                goToUserAccountDetail(productResponse: productResponse)
            }
        }
    }
}
