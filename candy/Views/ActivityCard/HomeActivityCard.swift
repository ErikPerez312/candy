//
//  HomeActivityCard.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

enum ActivityCardStatus {
    case homeDefault, inactiveDay, connecting
}

class HomeActivityCard: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        buildLabels()
        buildActivityIndicator()
        buildRules(withRules: rules)
        updateUIForStatus(.homeDefault)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Method not supported")
    }
    
    func updateUIForStatus(_ status: ActivityCardStatus) {
        switch status {
        case .homeDefault:
            rulesStackView?.isHidden = false
            footerLabel?.isHidden = false
            bodyLabel?.isHidden = true
            connectingIndicator?.isHidden = true
            connectingIndicator?.endAnimation()
        case .inactiveDay:
            rulesStackView?.isHidden = true
            footerLabel?.isHidden = true
            bodyLabel?.isHidden = false
            connectingIndicator?.isHidden = true
            connectingIndicator?.endAnimation()
        case .connecting:
            rulesStackView?.isHidden = true
            bodyLabel?.isHidden = true
            footerLabel?.isHidden = false
            headerLabel?.isHidden = false
            connectingIndicator?.isHidden = false
            connectingIndicator?.startAnimation()
        }
        updateLabelsTexts(forStatus: status)
    }
    
    // MARK: - Private
    
    private var headerLabel: UILabel?
    private var bodyLabel: UILabel?
    private var footerLabel:UILabel?
    private var rulesStackView: UIStackView?
    
    private var connectingIndicator: ActivityIndicatorView?
    
    private let rules = [
        "BE RESPECTFUL",
        "BE YOURSELF",
        "ASK QUESTIONS",
        "HAVE FUN",
        ]
    
    private func updateLabelsTexts(forStatus status: ActivityCardStatus) {
        switch status {
        case .homeDefault:
            headerLabel?.attributedText = CandyComponents.navigationBarTitleLabel(withTitle: "RULES").attributedText
            footerLabel?.attributedText = CandyComponents.attributedString(title: "PRESS CONNECT BELOW TO START CHATTING")
        case .inactiveDay:
            headerLabel?.attributedText = CandyComponents.navigationBarTitleLabel(withTitle: "COMEBACK LATER").attributedText
            bodyLabel?.attributedText = CandyComponents.navigationBarTitleLabel(withTitle: "CANDY IS AVAILABLE ON FRIDAYS AND SATURDAYS BETWEEN 7-9PM LOCAL TIME").attributedText
        case .connecting:
            headerLabel?.attributedText = CandyComponents.navigationBarTitleLabel(withTitle: "CONNECTING").attributedText
            footerLabel?.attributedText = CandyComponents.navigationBarTitleLabel(withTitle: "LOTS OF CANDY OUT THERE").attributedText
        }
    }
    
    private func setUpView() {
        layer.masksToBounds = false
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.candyNavigationBarShadow.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = CGFloat(38)
        layer.shadowOpacity = 1.0
        
        backgroundColor = .candyActivityCardBackground
    }
    
    private func buildRules(withRules rules: [String]) {
        let allRulesStackView = UIStackView()
        self.rulesStackView = allRulesStackView
        addSubview(allRulesStackView)
        allRulesStackView.axis = .vertical
        allRulesStackView.alignment = .fill
        allRulesStackView.distribution = .fill
        allRulesStackView.spacing = 20
        
        allRulesStackView.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(20)
            maker.top.equalToSuperview().offset(70)
        }
        
        rules.forEach { rule in
            let label = UILabel()
            label.attributedText = CandyComponents.attributedString(title: rule)
            let bulletPoint = UIView()
            bulletPoint.layer.cornerRadius = 5
            bulletPoint.backgroundColor = .candyBackgroundBlue
            bulletPoint.snp.makeConstraints { maker in
                maker.size.equalTo(CGSize(width: 17, height: 17))
            }
    
            let ruleStackView = UIStackView(arrangedSubviews: [bulletPoint, label])
            ruleStackView.axis = .horizontal
            ruleStackView.alignment = .fill
            ruleStackView.distribution = .fill
            ruleStackView.spacing = 8.0
            allRulesStackView.addArrangedSubview(ruleStackView)
        }
    }
    
    /// Builds header, body, and footer labels
    private func buildLabels() {
        let labelMaker: () -> UILabel = {
            let label = UILabel()
            self.addSubview(label)
            label.textAlignment = .center
            return label
        }
        
        let header = labelMaker()
        self.headerLabel = header
        header.numberOfLines = 1
        header.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(20)
            maker.top.equalToSuperview().offset(17)
        }
        let body = labelMaker()
        self.bodyLabel = body
        body.numberOfLines = 4
        body.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(10)
            maker.top.bottom.equalToSuperview()
        }
        let footer = labelMaker()
        self.footerLabel = footer
        footer.numberOfLines = 3
        footer.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(17)
            maker.bottom.equalToSuperview().inset(25)
        }
    }
    
    private func buildActivityIndicator() {
        let indicator = ActivityIndicatorView()
        addSubview(indicator)
        self.connectingIndicator = indicator
        indicator.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
            maker.size.equalTo(CGSize(width: 80, height: 80))
        }
    }
}
