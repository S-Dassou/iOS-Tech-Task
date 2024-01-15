//
//  Coordinator.swift
//  MoneyBox
//
//  Created by shafique dassu on 14/01/2024.
//

import Foundation
import UIKit
import Networking

/// The AppCoordinator is responsible for navigation throughout the entire app
class AppCoordinator {

    private var window: UIWindow?
    private var navigationController: UINavigationController?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    /**
     Provides list of potential view controllers to navigate to
     */
    enum Destination {
        case login, userAccounts, userAccountDetail
    }
    
    /**
     Determines the first view controller that will be shown after app launch
     */
    func start() {
        let loginViewModel = LoginViewModel(appCoordinator: self)
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        window!.rootViewController = loginViewController
        window!.makeKeyAndVisible()
    }
    
    /**
     Method that takes us to UserAccounts view controller
        - Parameters:
            - loginResponse: Derived from the networking module. Encapsulates logged in user.
     */
    private func goToUserAccounts(loginResponse: LoginResponse) {
        let userAccountsViewModel = UserAccountsViewModel(loginResponse: loginResponse, service: UserAccounts())
        userAccountsViewModel.appCoordinator = self
        let userAccountsViewController = UserAccountsViewController(viewModel: userAccountsViewModel)
        let userAccountsNavigationController = UINavigationController(rootViewController: userAccountsViewController)
        navigationController = userAccountsNavigationController
        window?.rootViewController = userAccountsNavigationController
    }
    
    /**
     Method that takes us to Login view controller
     */
    private func goToLogin() {
        let loginViewModel = LoginViewModel(appCoordinator: self)
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        window?.rootViewController = loginViewController
    }
    
    /**
     Method that takes us to UserAccountDetails view controller.
        - Parameters:
            - productResponse: Derived from the networking module. Contains details about a single user product.
     */
    private func goToUserAccountDetail(productResponse: ProductResponse) {
        let userAccountDetailViewModel = UserAccountsDetailViewModel(productResponse: productResponse)
        let userAccountDetailViewController = UserAccountDetailViewController(viewModel: userAccountDetailViewModel)
        navigationController?.pushViewController(userAccountDetailViewController, animated: true)
    }
    
    /**
     Method that takes us to a designated destination view controller.
        - Parameters:
            - destination: An enum type Destination representing one of several view controllers that we can navigate to
            - data: Any accompanying data needed when navigating to a view controller
     */
    func proceed(to destination: Destination, data: Any?) {
        switch destination {
        case .login:
            goToLogin()
        case .userAccounts:
            if let loginResponseUser = data as? LoginResponse {
                goToUserAccounts(loginResponse: loginResponseUser)
            }
        case .userAccountDetail:
            if let productResponse = data as? ProductResponse {
                goToUserAccountDetail(productResponse: productResponse)
            }
        }
    }
}
