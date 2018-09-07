//
//  UserAppearanceView.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import UIKit
import SnapKit

class UserAppearanceView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        buildLabels()
        updateUserCountLabel(withCount: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Method not supported")
    }
    
    func updateUserCountLabel(withCount count: Int) {
        onlineUserCountLabel?.attributedText = CandyComponents.attributedString(title: "\(count)")
    }
    
    // MARK: - Private
    
    private var onlineUserCountLabel: UILabel?
    
    private func setUpView() {
        backgroundColor = .candyActivityCardBackground
        layer.masksToBounds = false
        layer.cornerRadius = 13
        layer.shadowColor = UIColor.candyNavigationBarShadow.cgColor
        layer.shadowOffset = CGSize(width: 0, height: -3)
        layer.shadowRadius = 10.0
        layer.shadowOpacity = 1.0
    }
    
    private func buildLabels() {
        let titleLabel = UILabel()
        titleLabel.attributedText = CandyComponents.navigationBarTitleLabel(withTitle: "ONLINE USERS:").attributedText
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 1
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(20)
            maker.top.equalToSuperview().offset(10)
            maker.bottom.equalToSuperview().inset(10)
        }
        
        let userCountLabel = UILabel()
        self.onlineUserCountLabel = userCountLabel
        userCountLabel.numberOfLines = 1
        userCountLabel.textAlignment = .right
        addSubview(userCountLabel)
        
        userCountLabel.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview().inset(15)
            maker.top.equalToSuperview().offset(10)
            maker.bottom.equalToSuperview().inset(10)
        }
    }
}
