//
//  HomeViewController.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol HomePresentableListener: class {
    // Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func connect()
    func canceledConnection()
    func viewWillAppear()
    func viewWillDisappear()
}

final class HomeViewController: UIViewController, HomePresentable, HomeViewControllable {

    weak var listener: HomePresentableListener?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Method not supported")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .candyBackgroundPink
        let navigationBar = navigationController?.navigationBar
        // Removes UINavigationBar bottom hairline
        navigationBar?.setValue(true, forKey: "hidesShadow")
        navigationBar?.barTintColor = view.backgroundColor
        navigationItem.titleView = CandyComponents.navigationBarTitleLabel(withTitle: "CANDY")
        
        let views = buildMainViews()
        buildButtons(withAppearanceView: views.appearanceView, activityCard: views.activityCard)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listener?.viewWillAppear()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        listener?.viewWillDisappear()
    }
    
    // MARK: HomeViewControllable
    
    func push(viewController: ViewControllable) {
        navigationController?.pushViewController(viewController.uiviewController, animated: true)
    }

    func presentModally(viewController: ViewControllable) {
        present(viewController.uiviewController, animated: true, completion: nil)
    }
    
    func dismissModally(viewController: ViewControllable) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: HomePresentable
    
    func presentAppearanceCount(_ count: Int) {
        appearanceView?.updateUserCountLabel(withCount: count)
    }
    
    func updateActivityCard(withStatus status: ActivityCardStatus) {
        guard let connectButton = self.connectButton else { return }
        connectButton.isHidden = (status == .inactiveDay) ? true : false
        connectButton.isEnabled = status == .homeDefault
        cancelButton?.isHidden = connectButton.isEnabled
        cancelButton?.isEnabled = !connectButton.isEnabled
        activityCard?.updateUIForStatus(status)
    }
    
    // MARK: - Private
    
    private let bag = DisposeBag()
    private var activityCard: HomeActivityCard?
    private var appearanceView: UserAppearanceView?
    private var connectButton: UIButton?
    private var cancelButton: UIButton?
    
    private func buildMainViews() -> (appearanceView: UserAppearanceView, activityCard: HomeActivityCard) {
        let appearanceView = UserAppearanceView(frame: .zero)
        self.appearanceView = appearanceView
        view.addSubview(appearanceView)
        appearanceView.snp.makeConstraints { maker in
            maker.height.equalTo(40)
            maker.top.equalTo(view.snp.topMargin).offset(15)
            maker.leading.trailing.equalToSuperview().inset(32)
        }
        
        let card = HomeActivityCard(frame: .zero)
        self.activityCard = card
        view.addSubview(card)
        card.snp.makeConstraints { maker in
            if UIScreen.main.bounds.height < 600 {
                // Screen sizes smaller than iPhone-8
                maker.height.equalTo(300)
            } else {
                maker.height.greaterThanOrEqualTo(400).priority(900)
            }
            maker.top.equalTo(appearanceView.snp.bottom).offset(20)
            maker.leading.trailing.equalTo(appearanceView)
        }
        return (appearanceView, card)
    }
    
    private func buildButtons(withAppearanceView appearanceView: UserAppearanceView,
                              activityCard: HomeActivityCard) {
        
        let connectButton = UIButton(frame: .zero)
        self.connectButton = connectButton
        connectButton.backgroundColor = .candyBackgroundBlue
        connectButton.layer.cornerRadius = 6
        connectButton.setTitle("Connect", for: .normal)
        connectButton.setTitle("Connecting", for: .disabled)
        connectButton.addTarget(self, action: #selector(connectButtonPressed), for: .touchUpInside)
        view.addSubview(connectButton)
        connectButton.snp.makeConstraints { maker in
            maker.height.equalTo(45).priority(1000)
            maker.top.equalTo(activityCard.snp.bottom).offset(15)
            maker.leading.trailing.equalTo(appearanceView)
        }
        
        let cancelButton = UIButton(frame: .zero)
        self.cancelButton = cancelButton
        cancelButton.isHidden = connectButton.isEnabled
        cancelButton.setAttributedTitle(CandyComponents.underlinedAvenirAttributedString(withTitle: "Cancel"), for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { maker in
            maker.height.equalTo(20).priority(1000)
            maker.top.equalTo(connectButton.snp.bottom).offset(20)
            maker.bottom.lessThanOrEqualToSuperview().inset(25).priority(900)
            maker.centerX.equalToSuperview()
        }
    }
    
    @objc private func connectButtonPressed() {
        listener?.connect()
    }
    
    @objc private func cancelButtonPressed() {
        listener?.canceledConnection()
    }
}
