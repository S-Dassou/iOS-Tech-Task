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

class UserAccountsViewModel {
    
    let totalPlanValue = CurrentValueSubject<String?, Never>("Total Plan Value: £...")
    
    var accounts: [ProductResponse] = []
    var user: LoginResponse.User?
    
    typealias GetProductsCompletion = (Result<ProductResponse, Error>) -> Void
    
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
