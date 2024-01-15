//
//  UserAccountsServiceProtocol.swift
//  MoneyBox
//
//  Created by shafique dassu on 15/01/2024.
//

import Foundation
import Networking

protocol UserAccountsService {
    func getProducts(completion: @escaping (_ result: Result<AccountResponse, Error>) -> Void)
}
