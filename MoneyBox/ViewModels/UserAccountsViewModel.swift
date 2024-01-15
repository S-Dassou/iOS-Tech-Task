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
    var accounts: [ProductResponse] = []
    var user: LoginResponse.User?
    var appCoordinator: AppCoordinator?
    
    init(loginResponse: LoginResponse.User) {
        self.user = loginResponse
    }
    
   // typealias GetProductsCompletion = (Result<ProductResponse, Error>) -> Void
    
    /**
     Method that retrieves a list of products to be displayed in the table view on UserAccountsViewController. It uses an instance of DataProvider and the fetchProducts method within DataProvider to update accounts with the fetched products.
     */
    func getProducts(completion: @escaping () -> Void) {
        let dataProvider = DataProvider()
        dataProvider.fetchProducts { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let success):
                strongSelf.accounts = success.productResponses ?? []
                strongSelf.totalPlanValue.value = "Total Plan Value: £\(success.totalPlanValue ?? 0.0)"
                completion()
            case .failure(let failure):
                print(failure.localizedDescription)
                break
            }
        }
    }
}

