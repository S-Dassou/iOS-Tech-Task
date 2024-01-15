//
//  Extension+Result.swift
//  MoneyBoxTests
//
//  Created by shafique dassu on 15/01/2024.
//

import Foundation

extension Result {
    var isSuccess: Bool { if case .success = self { return true } else { return false } }
    var isError: Bool {  return !isSuccess  }
}
