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
    
    private let viewModel: UserAccountsViewModel
    
    lazy fileprivate var greetingMessageLabel: UILabel = {
       let greetingMessage = UILabel()
        greetingMessage.translatesAutoresizingMaskIntoConstraints = false
        greetingMessage.text = "User Accounts"
        greetingMessage.font = UIFont.style(.body)
        greetingMessage.textColor = UIColor.greyColor
        greetingMessage.text = "Hello \(viewModel.user.firstName ?? "sir/madam") \(viewModel.user.lastName ?? "")"
        return greetingMessage
    }()
    
    private var cancellables = Set<AnyCancellable>()
    
    lazy fileprivate var totalPlanValue: UILabel = {
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
    
    lazy fileprivate var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UserAccountTableViewCell.self, forCellReuseIdentifier: UserAccountTableViewCell.identifier)
        return tableView
    }()
    
    lazy fileprivate var activityStateIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    lazy fileprivate var emptyStateTitle: UILabel = {
        let title = UILabel()
         title.text = "Loading"
         title.textColor = UIColor.black
         return title
    }()
    
    lazy fileprivate var emptyStateMessage: UILabel = {
        let message = UILabel()
         message.text = "Fetching your money boxes"
         message.textColor = UIColor.black
         message.translatesAutoresizingMaskIntoConstraints = false
         return message
    }()
    
    init(viewModel: UserAccountsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Fatal error")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProducts()
    }
    
    
    private func setup() {
        view.backgroundColor = UIColor.white
        title = "User Accounts"
        
    }
    
    private func getProducts() {
        tableView.isHidden = true
        viewModel.getProducts { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.presentError(title: "Error", message: "Could not get accounts right now")
                }
            }
        }
    }
}

//MARK: - table view data source
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

//MARK: - table view delegate
extension UserAccountsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let account = viewModel.accounts[indexPath.row]
        viewModel.appCoordinator?.proceed(to: .userAccountDetail, data: account)
        }
}

//MARK: - Layout
extension UserAccountsViewController {
    fileprivate func layout() {
        [activityStateIndicator, emptyStateMessage ,greetingMessageLabel, totalPlanValue, tableView].forEach { uiView in
            view.addSubview(uiView)
        }
        
        NSLayoutConstraint.activate([
            
            activityStateIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityStateIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateMessage.topAnchor.constraint(equalTo: activityStateIndicator.bottomAnchor, constant: 10),
            emptyStateMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
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
}

