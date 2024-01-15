//
//  UserAccountTableViewCell.swift
//  MoneyBox
//
//  Created by shafique dassu on 13/01/2024.
//

import UIKit
import Networking

/// The UserAccountTableViewCell is responsible for displaying the user account information in the UserAccountViewController.
class UserAccountTableViewCell: UITableViewCell {
    
    static let identifier = "UserAccountTableViewCell"

    lazy var accountTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var planValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var moneyBoxLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func layout() {
        [accountTitleLabel, planValueLabel, moneyBoxLabel].forEach { uiView in
            addSubview(uiView)
        }
        
        NSLayoutConstraint.activate([
            accountTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            accountTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            planValueLabel.topAnchor.constraint(equalTo: accountTitleLabel.bottomAnchor, constant: 3),
            planValueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            moneyBoxLabel.topAnchor.constraint(equalTo: planValueLabel.bottomAnchor, constant: 3),
            moneyBoxLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5)
        ])
    }

    func configure(account: ProductResponse) {
       
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        let formattedTotalValue = formatter.string(from: (account.planValue ?? 0.0) as NSNumber)
        let formattedMoneyBoxLabel = formatter.string(from: (account.moneybox ?? 0.0) as NSNumber)
        
        self.accountTitleLabel.text = account.product?.friendlyName
        self.planValueLabel.text = "Plan Value: £\(formattedTotalValue ?? "0.00")"
        self.moneyBoxLabel.text = "MoneyBox: £\(formattedMoneyBoxLabel ?? "0.0")"
        accountTitleLabel.font = UIFont.style(.category)
        accountTitleLabel.textColor = UIColor.greyColor
        planValueLabel.font = UIFont.style(.formLabel)
        planValueLabel.textColor = UIColor.greyColor
        moneyBoxLabel.font = UIFont.style(.formLabel)
        moneyBoxLabel.textColor = UIColor.greyColor
    }

    //register cell when using
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

