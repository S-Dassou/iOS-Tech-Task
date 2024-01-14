//
//  UserAccountsViewController.swift
//  MoneyBox
//
//  Created by shafique dassu on 13/01/2024.
//

import Foundation
import UIKit
import Networking
import Combine

class UserAccountsViewController: UIViewController {
    //container view to hold "User Accounts" title, greeting message, total plan value
    
    private let viewModel = UserAccountsViewModel()
    
//    //think of naming
//    var accounts: [ProductResponse] = []
    var user: LoginResponse.User?
    
    lazy var greetingMessageLabel: UILabel = {
       let greetingMessage = UILabel()
        greetingMessage.translatesAutoresizingMaskIntoConstraints = false
        greetingMessage.text = "User Accounts"
        greetingMessage.font = UIFont.style(.body)
        greetingMessage.textColor = UIColor.greyColor
        if let user = user {
            greetingMessage.text = "Hello \(user.firstName ?? "sir/madam") \(user.lastName ?? "")"
        }
        return greetingMessage
    }()
    
    private var cancellables = Set<AnyCancellable>()
    
    lazy var totalPlanValue: UILabel = {
       let totalPlanValue = UILabel()
        totalPlanValue.translatesAutoresizingMaskIntoConstraints = false
        totalPlanValue.font = UIFont.style(.body)
        totalPlanValue.textColor = UIColor.greyColor
        viewModel.totalPlanValue
                .assign(to: \.text, on: totalPlanValue)
                .store(in: &cancellables)
        totalPlanValue.textColor = UIColor.black
        return totalPlanValue
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UserAccountTableViewCell.self, forCellReuseIdentifier: UserAccountTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        setup()
        getProducts()
    }
    
    func setup() {
        //remove black strip at top
        view.backgroundColor = UIColor.white
        title = "User Accounts"
        
    }
    
    func layout() {
        [greetingMessageLabel, totalPlanValue, tableView].forEach { uiView in
            view.addSubview(uiView)
        }
        
        NSLayoutConstraint.activate([
            
            greetingMessageLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            greetingMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            totalPlanValue.topAnchor.constraint(equalTo: greetingMessageLabel.bottomAnchor, constant: 10),
            totalPlanValue.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            tableView.topAnchor.constraint(equalTo: totalPlanValue.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    func getProducts() {
        viewModel.getProducts {
            self.tableView.reloadData()
        }
        
//        let dataProvider = DataProvider()
//        dataProvider.fetchProducts { [weak self] result in
//            guard let strongSelf = self else { return }
//            switch result {
//            case .success(let success):
//                let productResponses = success.productResponses
//                //changed response type to product response - returns 3 values
//                strongSelf.accounts = success.productResponses ?? []
////                DispatchQueue.main.async {
////                    strongSelf.totalPlanValue.text = "Total Plan Value: £\(success.totalPlanValue ?? 0.0)"
////                    strongSelf.totalPlanValue.font = UIFont.style(.body)
////                    strongSelf.totalPlanValue.textColor = UIColor.greyColor
////                    strongSelf.tableView.reloadData()
////                }
//            case .failure(let failure):
//                //create an alert
//                break
//            }
//        }
    }
}

extension UserAccountsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserAccountTableViewCell.identifier, for: indexPath) as! UserAccountTableViewCell
        let account = viewModel.accounts[indexPath.row]
        cell.configure(account: account)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.accounts.count
    }
}

extension UserAccountsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let account = viewModel.accounts[indexPath.row]
            let userAccountDetailViewController = UserAccountDetailViewController()
            userAccountDetailViewController.productResponse = account
            navigationController?.pushViewController(userAccountDetailViewController, animated: true)
        }
}
