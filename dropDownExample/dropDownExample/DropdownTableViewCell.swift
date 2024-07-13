//
//  DropdownTableViewCell.swift
//  XCARET!
//
//  Created by Cynthia Denisse Verdiales Moreno on 27/02/24.
//  Copyright © 2024 Angelica Can. All rights reserved.
//

import UIKit

class DropdownTableViewCell: UITableViewCell {

    lazy var countryName: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 46/255, green: 79/255, blue: 119/255, alpha: 1)
        return label
    }()
       
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
       super.init(style: style, reuseIdentifier: reuseIdentifier)
       setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       setupSubviews()
    }

    private func setupSubviews() {
       contentView.addSubview(countryName)
       
        NSLayoutConstraint.activate([
            countryName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            countryName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            countryName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            countryName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

}
