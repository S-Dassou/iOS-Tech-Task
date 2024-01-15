//
//  LoginError.swift
//  MoneyBox
//
//  Created by shafique dassu on 13/01/2024.
//
//
import Foundation
import UIKit

/**
 Enum representing different types of potential errors during login process. Provides an error title and error message which are returned in two cases; whether error is related to network issue or user input issue
 */
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
