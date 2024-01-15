//
//  Extension+UIButton.swift
//  MoneyBox
//
//  Created by shafique dassu on 13/01/2024.
//

import Foundation
import UIKit
import Combine

extension UIButton {
    
    /**
     Method that emits a signal when the button is tapped
     */
    func publishTap() -> AnyPublisher<Void, Never> {
        self.publisher(for: .touchUpInside)
            .map({ _ in
                return
            })
            .eraseToAnyPublisher()
    }
}
