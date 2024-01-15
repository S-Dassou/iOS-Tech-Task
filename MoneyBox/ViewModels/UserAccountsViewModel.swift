//
//  UserAccountsViewModel.swift
//  MoneyBox
//
//  Created by shafique dassu on 13/01/2024.
//

import Foundation
import UIKit
import Networking
import Combine

/// Class responsible for fetching products from the data provider. Products are displayed in UserAccountsViewController
class UserAccountsViewModel {
    
    let totalPlanValue = CurrentValueSubject<String?, Never>("Total Plan Value: £...")
    private var accountResponse: AccountResponse?
    private let loginResponse: LoginResponse
    private let service: UserAccountsService
    var accounts: [ProductResponse] {
        return accountResponse?.productResponses ?? []
    }
    var user: LoginResponse.User {
        return loginResponse.user
    }
    var session: LoginResponse.Session {
        return loginResponse.session
    }
    
    var appCoordinator: AppCoordinator?
    
    init(loginResponse: LoginResponse, service: UserAccountsService) {
        self.loginResponse = loginResponse
        self.service = service
    }
    
    func getProducts(completion: @escaping (_ result: Result<AccountResponse, Error>) -> Void) {
        service.getProducts { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let accountResponse):
                strongSelf.accountResponse = accountResponse
                strongSelf.totalPlanValue.value = "Total Plan Value: £\(accountResponse.totalPlanValue ?? 0.0)"
            case .failure(let failure):
                print(failure.localizedDescription)
            }
            completion(result)
        }
    }
    
}
