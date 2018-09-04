//
//  UserAppearanceView.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import UIKit

// TODO: Refactor

class UserAppearanceView: UIView {
    private var titleLabel: UILabel!
    private var onlineUserCountLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        setUpLabels()
        updateOnlineUserCountLabel(with: 0)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    func updateOnlineUserCountLabel(with count: Int) {
        onlineUserCountLabel.attributedText = CandyComponents.avenirAttributedString(title: "\(count)")
    }
    
    private func setUpView() {
        backgroundColor = .candyActivityCardBackground
        layer.masksToBounds = false
        layer.cornerRadius = 13
        layer.shadowColor = UIColor.candyNavigationBarShadow.cgColor
        layer.shadowOffset = CGSize(width: 0, height: -3)
        layer.shadowRadius = 10.0
        layer.shadowOpacity = 1.0
    }
    
    private func setUpLabels() {
        titleLabel = UILabel()
        titleLabel.attributedText = CandyComponents.navigationBarTitleLabel(withTitle: "ONLINE USERS:").attributedText
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 1
        addSubview(titleLabel)
        
        
        onlineUserCountLabel = UILabel()
        onlineUserCountLabel.numberOfLines = 1
        onlineUserCountLabel.textAlignment = .right
        addSubview(onlineUserCountLabel)
        
        addConstraintsToLabels()
    }
    
    private func addConstraintsToLabels() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        
        onlineUserCountLabel.translatesAutoresizingMaskIntoConstraints = false
        onlineUserCountLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        onlineUserCountLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        onlineUserCountLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
    }
}

