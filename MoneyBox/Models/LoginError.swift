//
//  LoginError.swift
//  MoneyBox
//
//  Created by shafique dassu on 13/01/2024.
//

import Foundation
import UIKit

enum LoginError: Error {
    case userInput, api
    var errorTitle: String {
        switch self {
        case .userInput:
            return "Invalid details"
        case .api:
            return "Something went wrong"
        }
    }
    var errorMessage: String {
        switch self {
        case .userInput:
            return "Please check your login details"
        case .api:
            return "Please try again later"
        }
    }
}
