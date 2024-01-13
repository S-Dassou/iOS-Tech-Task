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
    
    func publishTap() -> AnyPublisher<Void, Never> {
        self.publisher(for: .touchUpInside)
            .map({ _ in
                return
            })
            .eraseToAnyPublisher()
    }
    
}
