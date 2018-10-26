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
    /// User's local device date time indicate inactive day for candy.
    case inactiveDay
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
        buildUserImageAndNameViews()
        buildButtons()
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
            startChatButton?.isHidden = true
            startChatButton?.isEnabled = false
            nextUserButton?.isHidden = true
            nextUserButton?.isEnabled = false
            remoteUserFirstNameLabel?.isHidden = true
            
            footerLabel?.isHidden = false
            headerLabel?.isHidden = false
            connectingIndicator?.isHidden = false
            connectingIndicator?.startAnimation()
        case .profileView:
            bodyLabel?.isHidden = true
            footerLabel?.isHidden = true
            rulesStackView?.isHidden = true
            connectingIndicator?.isHidden = true
            
            startChatButton?.isHidden = false
            startChatButton?.isEnabled = true
            nextUserButton?.isHidden = false
            nextUserButton?.isEnabled = true
            remoteUserFirstNameLabel?.isHidden = false
            profileImageView?.isHidden = false
        }
        updateLabelsTexts(forStatus: status)
    }
    
    /// Use to download and update image view with image at url address.
    /// - Parameters:
    ///   - firstName: Remote user's first name
    ///   - imageLink: String representation  of remote user's profile image URL
    func updateProfileViews(withName firstName: String, imageLink: String) {
        remoteUserFirstNameLabel?.attributedText = CandyComponents.navigationBarTitleLabel(withTitle: firstName).attributedText
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
    /// Locatated at center of activity card. Allows up to 4 lines of text.
    private var bodyLabel: UILabel?
    /// Located at the bottom center of activity card. Allows up to 3 lines of text.
    private var footerLabel:UILabel?
    /// Soley used for displaying a remote user's first name.
    private var remoteUserFirstNameLabel: UILabel?
    
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
        case .inactiveDay:
            headerLabel?.attributedText = CandyComponents.navigationBarTitleLabel(withTitle: "COMEBACK LATER").attributedText
            bodyLabel?.attributedText = CandyComponents.navigationBarTitleLabel(withTitle: "CANDY IS AVAILABLE ON FRIDAYS AND SATURDAYS BETWEEN 7-9PM LOCAL TIME").attributedText
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
    
    private func buildConnectingActivityIndicator() {
        let indicator = ActivityIndicatorView()
        addSubview(indicator)
        self.connectingIndicator = indicator
        indicator.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
            maker.size.equalTo(CGSize(width: 80, height: 80))
        }
    }
    
    private func buildUserImageAndNameViews() {
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
            maker.top.equalTo(self.snp.topMargin).offset(90)
        }
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.isHidden = true
        self.imageDownloadActivityIndicator = indicator
        self.addSubview(indicator)
        indicator.snp.makeConstraints { maker in
            maker.size.equalTo(CGSize(width: 50, height: 50))
            maker.center.equalTo(imageView.snp.center)
        }
        
        let firstNameLabel = UILabel()
        self.remoteUserFirstNameLabel = firstNameLabel
        firstNameLabel.attributedText = CandyComponents.attributedString(title: "NAME")
        firstNameLabel.textAlignment = .center
        firstNameLabel.numberOfLines = 1
        
        self.addSubview(firstNameLabel)
        firstNameLabel.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(imageView.snp.bottomMargin).offset(10)
        }
    }
    
    private func buildButtons() {
        let buttonMaker: (String) -> UIButton = { title in
            let button = UIButton()
            button.layer.cornerRadius = 8
            button.backgroundColor = .candyBackgroundBlue
            button.setTitleColor(.white, for: .normal)
            button.setTitle(title, for: .normal)
            return button
        }
        let start = buttonMaker("Start")
        start.addTarget(self, action: #selector(startChatButtonPressed), for: .touchUpInside)
        self.startChatButton = start
        self.addSubview(start)
        start.snp.makeConstraints { maker in
            maker.top.equalTo(remoteUserFirstNameLabel!.snp.bottom).offset(20)
            maker.size.equalTo(CGSize(width: 155, height: 35))
            maker.centerX.equalToSuperview()
        }
        
        let next = buttonMaker("Next")
        next.addTarget(self, action: #selector(nextUserButtonPressed), for: .touchUpInside)
        self.nextUserButton = next
        self.addSubview(next)
        next.snp.makeConstraints { maker in
            maker.size.equalTo(CGSize(width: 85, height: 30))
            maker.top.equalTo(start.snp.bottom).offset(15)
            maker.centerX.equalToSuperview()
        }
    }
    
    @objc private func startChatButtonPressed() {
        delegate?.startChatButtonPressed()
    }
    
    @objc private func nextUserButtonPressed() {
        delegate?.nextUserButtonPressed()
    }
}
