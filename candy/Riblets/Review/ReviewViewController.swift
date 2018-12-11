//
//  ReviewViewController.swift
//  candy
//
//  Created by Erik Perez on 12/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol ReviewPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func closeButtonPressed()
}

final class ReviewViewController: UIViewController, ReviewPresentable, ReviewViewControllable {

    weak var listener: ReviewPresentableListener?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Method not supported")
    }
    
    override func viewDidLoad() {
        let backgroundCard = buildBackgroundViews()
        let titleLabel = buildHeaderViews(withCardView: backgroundCard)
        buildButtons(withBackgroundCard: backgroundCard, titleLabel: titleLabel)
    }
    
    
    // MARK: - Private
    
    private func buildBackgroundViews() -> UIView {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        let card = UIView()
        card.layer.cornerRadius = 10.0
        card.backgroundColor = .candyActivityCardBackground
        view.addSubview(card)
        card.snp.makeConstraints { maker in
            maker.height.equalTo(250)
            maker.leading.trailing.equalToSuperview().inset(30)
            maker.centerY.equalToSuperview()
        }
        return card
    }
    
    /// Builds title label and close button
    private func buildHeaderViews(withCardView card: UIView) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "Avenir-Black", size: 16.0)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .candyBackgroundBlue
        titleLabel.text = "RATE KAREN"
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { maker in
            maker.top.equalTo(card.snp.top).inset(30)
            maker.leading.trailing.equalTo(card)
        }
        
        let closeButton = UIButton()
        closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        closeButton.setAttributedTitle(CandyComponents.underlinedAttributedString(withTitle: "Close"), for: .normal)
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { maker in
            maker.trailing.equalTo(card).inset(4)
            maker.top.equalTo(card).offset(4)
            maker.height.equalTo(20)
        }
        return titleLabel
    }
    
    /// Builds 'Great, 'Poor', and 'Report and Block' buttons.
    private func buildButtons(withBackgroundCard card: UIView, titleLabel: UILabel) {
        let buttonMaker: (String) -> UIButton = { title in
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.layer.cornerRadius = 36 / 2
            button.backgroundColor = .candyBackgroundBlue
            button.setTitleColor(.white, for: .normal)
            card.addSubview(button)
            return button
        }
        
        let greatButton = buttonMaker("Great")
        greatButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        greatButton.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(43)
            maker.top.equalTo(titleLabel.snp.bottom).offset(25)
            maker.height.equalTo(36)
        }
        
        let poorButton = buttonMaker("Poor")
        poorButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        poorButton.snp.makeConstraints { maker in
            maker.leading.trailing.height.equalTo(greatButton)
            maker.top.equalTo(greatButton.snp.bottom).offset(10)
        }
        
        let reportButton = buttonMaker("Report and Block")
        reportButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        reportButton.backgroundColor = .deletingRed
        reportButton.snp.makeConstraints { maker in
            maker.leading.trailing.height.equalTo(greatButton)
            maker.top.equalTo(poorButton.snp.bottom).offset(10)
        }
    }
    
    @objc private func closeButtonPressed() {
        listener?.closeButtonPressed()
    }
}
