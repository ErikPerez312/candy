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
    
    func push(viewController: ViewControllable) {
        navigationController?.pushViewController(viewController.uiviewController, animated: true)
    }
    
    func presentModally(viewController: ViewControllable) {
        present(viewController.uiviewController, animated: true, completion: nil)
    }
    
    // MARK: - Private
    
    private let bag = DisposeBag()
    private var activityCard: HomeActivityCard!
    
    private func buildMainViews() -> (appearanceView: UserAppearanceView, activityCard: HomeActivityCard) {
        let appearanceView = UserAppearanceView(frame: .zero)
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
        connectButton.backgroundColor = .candyBackgroundBlue
        connectButton.layer.cornerRadius = 6
        connectButton.setTitle("Connect", for: .normal)
        connectButton.setTitle("Connecting", for: .disabled)
        connectButton.rx.tap
            .subscribe(onNext:{ [weak self] in
                self?.listener?.connect()
            })
            .disposed(by: bag)
        
        view.addSubview(connectButton)
        connectButton.snp.makeConstraints { maker in
            maker.height.equalTo(45).priority(1000)
            maker.top.equalTo(activityCard.snp.bottom).offset(15)
            maker.leading.trailing.equalTo(appearanceView)
        }
        
        let cancelButton = UIButton(frame: .zero)
        cancelButton.isHidden = connectButton.isEnabled
        cancelButton.setAttributedTitle(CandyComponents.underlinedAvenirAttributedString(withTitle: "Cancel"), for: .normal)
        cancelButton.rx.tap
            .subscribe(onNext:{ [weak self] in
                self?.listener?.canceledConnection()
            })
            .disposed(by: bag)
        view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { maker in
            maker.height.equalTo(20).priority(1000)
            maker.top.equalTo(connectButton.snp.bottom).offset(20)
            maker.bottom.lessThanOrEqualToSuperview().inset(25).priority(900)
            maker.centerX.equalToSuperview()
        }
    }
    
}
