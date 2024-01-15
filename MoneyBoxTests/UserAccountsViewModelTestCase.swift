//
//  UserAccountsViewModelTestCase.swift
//  MoneyBoxTests
//
//  Created by shafique dassu on 15/01/2024.
//

import XCTest
import Networking
@testable import MoneyBox

struct DummyUserAccounts: UserAccountsService {
    func getProducts(completion: @escaping (_ result: Result<AccountResponse, Error>) -> Void) {
        StubData.read(file: "Accounts") { (result: Result<AccountResponse, Error>) in
            completion(result)
        }
    }
}

final class UserAccountsViewModelTestCase: XCTestCase {
    
    var viewModel: UserAccountsViewModel!

    override func setUpWithError() throws {
        StubData.read(file: "LoginSucceed") { (result: Result<LoginResponse, Error>) in
            XCTAssertTrue(result.isSuccess)
            switch result {
            case .success(let loginResponse):
                self.viewModel = UserAccountsViewModel(loginResponse: loginResponse, service: DummyUserAccounts())
                self.viewModel.getProducts { _ in }
            case .failure(_):
                break
            }
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFirstName() throws {
        XCTAssertTrue(viewModel.user.firstName == "Michael")
    }
    
    func testLastName() throws {
        XCTAssertTrue(viewModel.user.lastName == "Jordan")
    }
    
    func testSession() throws {
        XCTAssertTrue(viewModel.session.bearerToken == "GuQfJPpjUyJH10Og+hS9c0ttz4q2ZoOnEQBSBP2eAEs=")
    }
    
    func testTotalPlanValue() throws {
        XCTAssertTrue("Total Plan Value: £15707.08" == viewModel.totalPlanValue.value)
    }
    
    func testNumberOfAccounts() throws {
        XCTAssertTrue(viewModel.accounts.count == 2)
    }
    
    func testAccountIds() {
        XCTAssertTrue(viewModel.accounts.contains { $0.id == 8043 } && viewModel.accounts.contains { $0.id == 8042 })
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

