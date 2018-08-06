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
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func connect()
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
        view.backgroundColor = UIColor.candyNavigationBarShadow
        // Removes UINavigationBar bottom hairline
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        buildActivityCard()
        buildButtons()
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
    
    private func buildActivityCard() {
        let card = HomeActivityCard(frame: .zero)
        self.activityCard = card
        view.addSubview(card)
        card.snp.makeConstraints { maker in
            maker.top.equalTo(view.snp.topMargin).offset(100)
            maker.bottom.equalTo(view).inset(100)
            maker.leading.trailing.equalTo(view).inset(32)
        }
    }
    
    private func buildButtons() {
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
            maker.leading.trailing.equalToSuperview().inset(32)
        }
    }
    
}
