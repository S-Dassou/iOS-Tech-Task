//
//  LoginViewModel.swift
//  MoneyBox
//
//  Created by shafique dassu on 13/01/2024.
//

import Foundation
import UIKit
import Networking
import Combine

class LoginViewModel {
    
    let email = CurrentValueSubject<String, Never>("")
    let password = CurrentValueSubject<String, Never>("")
    
    typealias LoginCompletion = (Result<LoginResponse.User, LoginError>) -> Void
    
    func login(completion: @escaping LoginCompletion) {
        
        guard !email.value.isEmpty,
              !password.value.isEmpty else {
            completion(.failure(LoginError.userInput))
            return
        }
        
        let logInRequest = LoginRequest(email: email.value, password: password.value)
        
        let dataProvider = DataProvider()
        dataProvider.login(request: logInRequest) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let loginResponse):
                Authentication.token = loginResponse.session.bearerToken
                completion(.success(loginResponse.user))
                return
                
            case .failure(let failure):
                print(failure.localizedDescription)
                completion(.failure(LoginError.api))
            }
        }
    }
}
