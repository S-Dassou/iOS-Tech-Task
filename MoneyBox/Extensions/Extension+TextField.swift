//
//  Extension+TextField.swift
//  MoneyBox
//
//  Created by shafique dassu on 13/01/2024.
//

import Foundation
import UIKit
import Combine

/// Extension that allows for two way binding between text field and a subject
extension UITextField {
    
    
    /// Method that gives us the current text of a text field upon it changing
    func textPublisher() -> AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap({ ($0.object as? UITextField)?.text })
            .eraseToAnyPublisher()
    }
    /**
     Method that binds to a current value subject - allows the text field in UserAccountsViewController to be responsive to changes in the text field in UserAccountsDetailViewController
        - Parameters:
            - subject: Holds onto a stream of values over time. Ensures synchronisation between text field and subject.
            - subscriptions: Keeps a track of the subscriptions created within the bind function. Able to store cancellables in this set and then dispose when no longer required.
     */
    func bind(with subject: CurrentValueSubject<String, Never>,
                       storeIn subscriptions: inout Set<AnyCancellable>) {
        
        subject.sink { [weak self] (value) in
            if value != self?.text {
                self?.text = value
            }
        }.store(in: &subscriptions)
        
        self.textPublisher().sink { (value) in
            if value != subject.value {
                subject.send(value)
            }
        }.store(in: &subscriptions)
    }
}
