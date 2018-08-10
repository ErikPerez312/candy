//
//  HomeActivityCard.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import Foundation
import UIKit

// TODO: Refactor

enum ActivityCardStatus {
    case homeDefault, inactiveDay, connecting
}

class HomeActivityCard: ActivityCard {
    // MARK: Properties
    private var headerLabel = UILabel()
    private var bodyLabel = UILabel()
    private var footerLabel = UILabel()
    private var ruleLabels = [UILabel]()
    private var bulletPoints = [BulletPoint]()
    private var rulesStackView: UIStackView!
    
    var connectingActivityIndicator = ActivityIndicatorView()
    
    private var rules = [
        "BE RESPECTFUL",
        "BE YOURSELF",
        "ASK QUESTIONS",
        "HAVE FUN",
        ]
    
    //MARK: View Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUIElements()
        updateUIForStatus(.homeDefault)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Methods
    private func setUpUIElements() {
        rulesStackView = setUpRulesAndBulletPointsWithStackView()
        addSubview(rulesStackView)
        addSubview(headerLabel)
        addSubview(bodyLabel)
        addSubview(footerLabel)
        addSubview(connectingActivityIndicator)
        
        updateTextForLabelsWithStatus(.homeDefault)
        setUpLabelsAndConstraints()
        addBulletPointConstraints()
        addRulesStackViewConstraints()
        addActivityIndicatorConstraints()
    }
    
    func updateUIForStatus(_ status: ActivityCardStatus) {
        switch status {
        case .homeDefault:
            rulesStackView.isHidden = false
            footerLabel.isHidden = false
            bodyLabel.isHidden = true
            connectingActivityIndicator.isHidden = true
            connectingActivityIndicator.endIndicator()
            updateTextForLabelsWithStatus(.homeDefault)
        case .inactiveDay:
            rulesStackView.isHidden = true
            footerLabel.isHidden = true
            bodyLabel.isHidden = false
            connectingActivityIndicator.isHidden = true
            connectingActivityIndicator.endIndicator()
            updateTextForLabelsWithStatus(.inactiveDay)
        case .connecting:
            rulesStackView.isHidden = true
            bodyLabel.isHidden = true
            footerLabel.isHidden = false
            headerLabel.isHidden = false
            connectingActivityIndicator.isHidden = false
            connectingActivityIndicator.startIndicator()
            updateTextForLabelsWithStatus(.connecting)
        }
    }
    
    private func updateTextForLabelsWithStatus(_ status: ActivityCardStatus) {
        switch status {
        case .homeDefault:
            headerLabel.attributedText = CandyComponents.navigationBarTitleLabel(withTitle: "RULES").attributedText
            footerLabel.attributedText = CandyComponents.avenirAttributedString(title: "PRESS CONNECT BELOW TO START CHATTING")
        case .inactiveDay:
            headerLabel.attributedText = CandyComponents.navigationBarTitleLabel(withTitle: "COMBACK LATER").attributedText
            bodyLabel.attributedText = CandyComponents.navigationBarTitleLabel(withTitle: "CANDY IS AVAILABLE ON FRIDAY'S AND SATURDAY'S BETWEEN 7-9PM LOCAL TIME").attributedText
        case .connecting:
            headerLabel.attributedText = CandyComponents.navigationBarTitleLabel(withTitle: "CONNECTING").attributedText
            footerLabel.attributedText = CandyComponents.navigationBarTitleLabel(withTitle: "LOTS OF CANDY OUT THERE").attributedText
        }
    }
    
    private func setUpRulesAndBulletPointsWithStackView() -> UIStackView{
        let allRulesStackView = UIStackView()
        allRulesStackView.axis = .vertical
        allRulesStackView.alignment = .fill
        allRulesStackView.distribution = .fill
        allRulesStackView.spacing = 20
        
        rules.forEach { (rule) in
            let label = UILabel()
            let bulletPoint = BulletPoint()
            let rulesStackView = UIStackView(arrangedSubviews: [bulletPoint, label])
            rulesStackView.axis = .horizontal
            rulesStackView.alignment = .fill
            rulesStackView.distribution = .fill
            rulesStackView.spacing = 8.0
            
            label.attributedText = CandyComponents.avenirAttributedString(title: rule)
            ruleLabels.append(label)
            bulletPoints.append(bulletPoint)
            allRulesStackView.addArrangedSubview(rulesStackView)
        }
        return allRulesStackView
    }
    
    private func addBulletPointConstraints() {
        bulletPoints.forEach { (point) in
            point.widthAnchor.constraint(equalToConstant: 17).isActive = true
            point.heightAnchor.constraint(equalToConstant: 17).isActive = true
        }
    }
    
    private func addActivityIndicatorConstraints() {
        connectingActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        connectingActivityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        connectingActivityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        connectingActivityIndicator.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        connectingActivityIndicator.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
    }
    
    /// Sets up constraints and core properties for Header, Body, and Footer labels of the Activity Card
    private func setUpLabelsAndConstraints() {
        headerLabel.numberOfLines = 1
        headerLabel.textAlignment = .center
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 17).isActive = true
        headerLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        headerLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        
        bodyLabel.numberOfLines = 4
        bodyLabel.textAlignment = .center
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        bodyLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bodyLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        bodyLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        footerLabel.numberOfLines = 3
        footerLabel.textAlignment = .center
        footerLabel.translatesAutoresizingMaskIntoConstraints = false
        footerLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 17).isActive = true
        footerLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -17).isActive = true
        footerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25).isActive = true
    }
    
    private func addRulesStackViewConstraints() {
        rulesStackView.translatesAutoresizingMaskIntoConstraints = false
        rulesStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        rulesStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        rulesStackView.topAnchor.constraint(equalTo: topAnchor, constant: 70).isActive = true
    }
}
