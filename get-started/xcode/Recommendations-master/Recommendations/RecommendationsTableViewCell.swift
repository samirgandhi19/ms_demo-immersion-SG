//
//  RecommendationsTableViewCell.swift
//  Recommendations
//
//  Created by Alan Cota on 8/10/17.
//  Copyright © 2017 CA Technologies. All rights reserved.
//

import UIKit

class RecommendationsTableViewCell: UITableViewCell {
    
    let lblCell = UILabel()
    
    // MARK: Initalizers
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let marginGuide = contentView.layoutMarginsGuide
        
        // configure nameLabel
        contentView.addSubview(lblCell)
        lblCell.translatesAutoresizingMaskIntoConstraints = false
        lblCell.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        lblCell.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        lblCell.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        lblCell.numberOfLines = 0
        lblCell.font = UIFont.systemFont(ofSize: 13)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
