//
//  UserAccountDetailViewController.swift
//  MoneyBox
//
//  Created by shafique dassu on 13/01/2024.
//

import UIKit
import Networking
import Combine

class UserAccountDetailViewController: UIViewController {

    private let viewModel: UserAccountsDetailViewModel
    
    lazy fileprivate var accountTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.productResponse.product?.friendlyName
        label.font = UIFont.style(.category)
        label.textColor = UIColor.greyColor
        return label
    }()
    
    lazy fileprivate var planValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.style(.formLabel)
        label.textColor = UIColor.greyColor
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        let formattedTotalValue = formatter.string(from: (viewModel.productResponse.planValue ?? 0.0) as NSNumber)
        
        label.text = "Plan Value: £\(formattedTotalValue ?? "0.00")"
        return label
    }()
    
    lazy fileprivate var moneyBoxLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.style(.formLabel)
        label.textColor = UIColor.greyColor
        viewModel.moneyBoxValue
                .assign(to: \.text, on: label)
                .store(in: &cancellables)
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        let formattedMoneyBoxLabel = formatter.string(from: (viewModel.productResponse.moneybox ?? 0.0) as NSNumber)
        
        label.text = "MoneyBox: £\(formattedMoneyBoxLabel ?? "0.0")"
        return label
    }()
    
    lazy fileprivate var addMoneyButton: UIButton = {
       let button = RoundedButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add Money", for: .normal)
        button.backgroundColor = UIColor(named: "AccentColor")
        button.publishTap().sink { [weak self] in
            guard let strongSelf = self else { return }
            guard let productid = strongSelf.viewModel.productResponse.id else {
                return
            }
            strongSelf.viewModel.addMoney(productid: productid)
        }
        .store(in: &cancellables)
        return button
    }()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: UserAccountsDetailViewModel) {
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
    
    private func setup() {
        title = "Individual Account"
        view.backgroundColor = UIColor.white
    }
    
}

//MARK: - Layout
extension UserAccountDetailViewController {
    
    fileprivate func layout() {
        [accountTitleLabel, planValueLabel, moneyBoxLabel, addMoneyButton].forEach { uiView in
            view.addSubview(uiView)
        }
        NSLayoutConstraint.activate([
            accountTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            accountTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            planValueLabel.topAnchor.constraint(equalTo: accountTitleLabel.bottomAnchor, constant: 10),
            planValueLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            moneyBoxLabel.topAnchor.constraint(equalTo: planValueLabel.bottomAnchor, constant: 10),
            moneyBoxLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            addMoneyButton.topAnchor.constraint(equalTo: moneyBoxLabel.bottomAnchor, constant: 50),
            addMoneyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            addMoneyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }
    
}
