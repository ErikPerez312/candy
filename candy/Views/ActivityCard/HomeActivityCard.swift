//
//  HomeActivityCard.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import UIKit
import SnapKit

protocol HomeActivityCardDelegate: class {
    func startChatButtonPressed()
    func nextUserButtonPressed()
}

enum ActivityCardStatus {
    /// Default state for activity card. Card displays app rules.
    case homeDefault
    /// Use when user is attempting to find a chat partner
    case connecting
    /// Use to display remote user's info. This allows local user to initiate or decline the video chat.
    /// - Note: updateProfileViews(withName:imageLink:) should be used.
    case profileView
}

final class HomeActivityCard: UIView {
    
    weak var delegate: HomeActivityCardDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        buildLabels()
        buildConnectingActivityIndicator()
        buildRules(withRules: rules)
        buildUserInfoViews()
        buildChatControlButtons()
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
            startChatButton?.isHidden = true
            startChatButton?.isEnabled = false
            nextUserButton?.isHidden = true
            nextUserButton?.isEnabled = false
            remoteUserFirstNameLabel?.isHidden = true
            genderAndAgeLabel?.isHidden = true
            bioLabel?.isHidden = true
            profileImageView?.isHidden = true
            profileImageView?.image = nil
            
            connectingIndicator?.isHidden = true
            connectingIndicator?.endAnimation()
        case .connecting:
            rulesStackView?.isHidden = true
            startChatButton?.isHidden = true
            startChatButton?.isEnabled = false
            nextUserButton?.isHidden = true
            nextUserButton?.isEnabled = false
            remoteUserFirstNameLabel?.isHidden = true
            genderAndAgeLabel?.isHidden = true
            bioLabel?.isHidden = true
            profileImageView?.isHidden = true
            profileImageView?.image = nil
            
            footerLabel?.isHidden = false
            headerLabel?.isHidden = false
            connectingIndicator?.isHidden = false
            connectingIndicator?.startAnimation()
        case .profileView:
            footerLabel?.isHidden = true
            rulesStackView?.isHidden = true
            connectingIndicator?.isHidden = true
            
            startChatButton?.isHidden = false
            startChatButton?.isEnabled = true
            nextUserButton?.isHidden = false
            nextUserButton?.isEnabled = true
            remoteUserFirstNameLabel?.isHidden = false
            profileImageView?.isHidden = false
            remoteUserFirstNameLabel?.isHidden = false
            genderAndAgeLabel?.isHidden = false
            bioLabel?.isHidden = false
        }
        updateLabelsTexts(forStatus: status)
    }
    
    /// Use to download and update image view with image at url address.
    /// - Parameters:
    ///   - firstName: Remote user's first name
    ///   - imageLink: String representation  of remote user's profile image URL
    func updateProfileViews(withName firstName: String, imageLink: String, gender: String, age: String, bio: String) {
        remoteUserFirstNameLabel?.attributedText = CandyComponents.navigationBarTitleLabel(withTitle: firstName).attributedText
        genderAndAgeLabel?.attributedText = CandyComponents.navigationBarTitleLabel(withTitle: "\(gender), \(age)").attributedText
        bioLabel?.attributedText = CandyComponents.navigationBarTitleLabel(withTitle: bio.uppercased()).attributedText
        
        imageDownloadActivityIndicator?.isHidden = false
        imageDownloadActivityIndicator?.startAnimating()
        
        CandyAPI.downloadImage(withLink: imageLink) { (image) in
            DispatchQueue.main.async {
                self.imageDownloadActivityIndicator?.stopAnimating()
                guard let image = image else { return }
                self.profileImageView?.image = image
            }
        }
    }
    
    // MARK: - Private
    
    /// Single line title label
    private var headerLabel: UILabel?
    /// Located at the bottom center of activity card. Allows up to 3 lines of text.
    private var footerLabel:UILabel?
    /// Soley used for displaying a remote user's first name.
    private var remoteUserFirstNameLabel: UILabel?
    /// Soley used for displaying a remote user's gender and age.
    private var genderAndAgeLabel: UILabel?
    /// Soley used for displaying a remote user's bio
    private var bioLabel: UILabel?
    
    private var rulesStackView: UIStackView?
    private var profileImageView: UIImageView?
    private var startChatButton: UIButton?
    private var nextUserButton: UIButton?
    
    /// Huge custom indicator used when attempting to find a chat partner.
    private var connectingIndicator: ActivityIndicatorView?
    /// Soley used to indicate image download process.
    private var imageDownloadActivityIndicator: UIActivityIndicatorView?
    
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
        case .connecting:
            headerLabel?.attributedText = CandyComponents.navigationBarTitleLabel(withTitle: "CONNECTING").attributedText
            footerLabel?.attributedText = CandyComponents.navigationBarTitleLabel(withTitle: "LOTS OF CANDY OUT THERE").attributedText
        case .profileView:
            headerLabel?.attributedText = CandyComponents.navigationBarTitleLabel(withTitle: "CHAT WITH").attributedText
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
            maker.height.equalTo(19)
        }
        let footer = labelMaker()
        self.footerLabel = footer
        footer.numberOfLines = 3
        footer.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(17)
            maker.bottom.equalToSuperview().inset(25)
        }
    }
    
    private func buildConnectingActivityIndicator() {
        let indicator = ActivityIndicatorView()
        addSubview(indicator)
        self.connectingIndicator = indicator
        indicator.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
            maker.size.equalTo(CGSize(width: 80, height: 80))
        }
    }
    
    /// Builds profile image view, name label, and gender/age label
    private func buildUserInfoViews() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 129, height: 129))
        self.profileImageView = imageView
        imageView.layer.borderWidth = 3
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.candyBackgroundBlue.cgColor
        imageView.layer.cornerRadius = imageView.frame.height/2
        
        imageView.image = UIImage(named: "default-user.png")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        self.addSubview(imageView)
        imageView.snp.makeConstraints { maker in
            maker.size.equalTo(CGSize(width: 129, height: 129))
            maker.centerX.equalToSuperview()
            maker.top.equalTo(headerLabel!.snp.bottom).offset(24)
        }
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.isHidden = true
        self.imageDownloadActivityIndicator = indicator
        self.addSubview(indicator)
        indicator.snp.makeConstraints { maker in
            maker.size.equalTo(CGSize(width: 50, height: 50))
            maker.center.equalTo(imageView.snp.center)
        }
        
        let labelMaker: (String) -> UILabel = { text in
            let label = UILabel()
            label.attributedText = CandyComponents.attributedString(title: text)
            label.textAlignment = .center
            label.numberOfLines = 1
            return label
        }
        let firstNameLabel = labelMaker("NAME")
        self.remoteUserFirstNameLabel = firstNameLabel
        self.addSubview(firstNameLabel)
        firstNameLabel.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(imageView.snp.bottomMargin).offset(10)
            maker.height.equalTo(19)
        }
        let genderAndAgeLabel = labelMaker("GENDER, 00")
        self.genderAndAgeLabel = genderAndAgeLabel
        self.addSubview(genderAndAgeLabel)
        genderAndAgeLabel.snp.makeConstraints { maker in
            maker.leading.trailing.equalTo(firstNameLabel)
            maker.top.equalTo(firstNameLabel.snp.bottom).offset(2)
            maker.height.equalTo(firstNameLabel)
        }
        let bioLabel = labelMaker("One sentance bio".uppercased())
        self.bioLabel = bioLabel
        self.addSubview(bioLabel)
        bioLabel.snp.makeConstraints { maker in
            maker.leading.trailing.equalTo(firstNameLabel)
            maker.top.equalTo(genderAndAgeLabel.snp.bottom).offset(9)
        }
    }
    
    private func buildChatControlButtons() {
        let buttonMaker: (String) -> UIButton = { title in
            let button = UIButton()
            button.layer.cornerRadius = 8
            button.backgroundColor = .candyBackgroundBlue
            button.setTitleColor(.white, for: .normal)
            button.setTitle(title, for: .normal)
            return button
        }
        
        let accept = buttonMaker("Accept")
        accept.addTarget(self, action: #selector(startChatButtonPressed), for: .touchUpInside)
        self.startChatButton = accept
        self.addSubview(accept)
        accept.snp.makeConstraints { maker in
            maker.size.equalTo(CGSize(width: 112, height: 36))
            maker.leading.equalToSuperview().offset(24)
            maker.bottom.equalToSuperview().offset(-23)
            maker.top.equalTo(bioLabel!.snp.bottom).offset(13)
        }
        let next = buttonMaker("Next")
        next.addTarget(self, action: #selector(nextUserButtonPressed), for: .touchUpInside)
        self.nextUserButton = next
        self.addSubview(next)
        next.snp.makeConstraints { maker in
            maker.size.equalTo(accept)
            maker.trailing.equalToSuperview().offset(-24)
            maker.bottom.equalTo(accept)
            maker.top.equalTo(accept)
        }
    }
    
    @objc private func startChatButtonPressed() {
        delegate?.startChatButtonPressed()
    }
    
    @objc private func nextUserButtonPressed() {
        delegate?.nextUserButtonPressed()
    }
}
