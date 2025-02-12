//
//  UIViewController.swift
//  MoneyBox
//
//  Created by shafique dassu on 13/01/2024.
//

import Foundation
import UIKit

///extension on UIViewController to allow us to call a customised error message on any view controller
extension UIViewController {
    
    func presentError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
