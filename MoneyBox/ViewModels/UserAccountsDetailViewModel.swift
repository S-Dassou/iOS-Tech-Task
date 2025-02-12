//
//  UserAccountsDetailViewModel.swift
//  MoneyBox
//
//  Created by shafique dassu on 13/01/2024.
//

import Foundation
import UIKit
import Networking
import Combine

/// Class responsible for handling functionality to add fixed amount of money to a user's moneybox
class UserAccountsDetailViewModel {
    
    let moneyBoxValue = CurrentValueSubject<String?, Never>("Total Plan Value: £...")
    let productResponse: ProductResponse
    
    init(productResponse: ProductResponse) {
        self.productResponse = productResponse
    }
    
    /**
     Method that initiates a request to add £10 to the moneybox. Creates a payment request and uses DataProvider to process it.
        - Parameters:
            - productId: Int representing unique ID of the product to add the £10 to
     */
    func addMoney(productid: Int) {
        let oneOffPaymentRequest = OneOffPaymentRequest(amount: 10, investorProductID: productid)
        let dataProvider = DataProvider()
        dataProvider.addMoney(request: oneOffPaymentRequest) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let paymentResponse):
                let formatter = NumberFormatter()
                formatter.numberStyle = .currency
                formatter.currencySymbol = ""
                let formattedMoneyBoxAmount = formatter.string(from: (paymentResponse.moneybox ?? 0.0) as NSNumber) ?? "£0.00"
                DispatchQueue.main.async {
                    strongSelf.moneyBoxValue.value = "MoneyBox: £\(formattedMoneyBoxAmount)"
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                break
                
            }
        }
    }
}
