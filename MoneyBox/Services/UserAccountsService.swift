//
//  UserAccountsService.swift
//  MoneyBox
//
//  Created by shafique dassu on 15/01/2024.
//

import Foundation
import Networking

struct UserAccounts: UserAccountsService {
    
    /**
     Method that retrieves a list of products to be displayed in the table view on UserAccountsViewController. It uses an instance of DataProvider and the fetchProducts method within DataProvider to update accounts with the fetched products.
     */
    func getProducts(completion: @escaping (_ result: Result<AccountResponse, Error>) -> Void) {
        let dataProvider = DataProvider()
        dataProvider.fetchProducts { result in
            completion(result)
        }
    }
}
