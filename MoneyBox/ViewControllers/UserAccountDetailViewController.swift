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

    var productResponse: ProductResponse!
    let viewModel = UserAccountsDetailViewModel()
    
    lazy fileprivate var accountTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = productResponse.product?.friendlyName
        return label
    }()
    
    lazy fileprivate var planValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        let formattedTotalValue = formatter.string(from: (productResponse.planValue ?? 0.0) as NSNumber)
        
        label.text = "Plan Value: £\(formattedTotalValue ?? "0.00")"
        return label
    }()
    
    lazy var moneyBoxLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        viewModel.moneyBoxValue
                .assign(to: \.text, on: label)
                .store(in: &cancellables)
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        let formattedMoneyBoxLabel = formatter.string(from: (productResponse.moneybox ?? 0.0) as NSNumber)
        
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
            guard let productid = strongSelf.productResponse.id else {
                return
            }
            strongSelf.viewModel.addMoney(productid: productid)
        }
        .store(in: &cancellables)
        return button
    }()
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        setup()
    }
    
    private func setup() {
        title = "Individual Account"
        view.backgroundColor = UIColor.white
        accountTitleLabel.font = UIFont.style(.category)
        accountTitleLabel.textColor = UIColor.greyColor
        planValueLabel.font = UIFont.style(.formLabel)
        planValueLabel.textColor = UIColor.greyColor
        moneyBoxLabel.font = UIFont.style(.formLabel)
        moneyBoxLabel.textColor = UIColor.greyColor
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
