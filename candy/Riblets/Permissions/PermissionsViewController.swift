//
//  PermissionsViewController.swift
//  candy
//
//  Created by Erik Perez on 8/27/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import SnapKit
import AVFoundation

protocol PermissionsPresentableListener: class {
    // Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func requestCameraAccess()
    func requestMicrophoneAccess()
}

final class PermissionsViewController: UIViewController, PermissionsPresentable, PermissionsViewControllable {

    weak var listener: PermissionsPresentableListener?
    
    init(cameraAccessStatus: AVAuthorizationStatus,
         microphoneAccessStatus: AVAuthorizationStatus) {
        
        self.cameraAccessStatus = cameraAccessStatus
        self.microphoneAccessStatus = microphoneAccessStatus
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overCurrentContext
        let cardView = buildBackgroundViews()
        let titleLabel = buildHeaderViews(withCardView: cardView)
        buildButtons(withCardView: cardView, label: titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Method not supported")
    }
    
    // MARK: - Private
    
    private let bag = DisposeBag()
    private let cameraAccessStatus: AVAuthorizationStatus
    private let microphoneAccessStatus: AVAuthorizationStatus
    
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
            maker.height.equalTo(200)
            maker.leading.trailing.equalToSuperview().inset(30)
            maker.bottom.equalToSuperview().inset(50)
        }
        return card
    }
    
    private func buildHeaderViews(withCardView card: UIView) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "Avenir-Black", size: 16.0)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .candyBackgroundBlue
        titleLabel.text = "CANDY NEEDS PERMISSIONS"
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { maker in
            maker.top.equalTo(card.snp.top).inset(30)
            maker.leading.trailing.equalTo(card)
        }
        
        let closeButton = UIButton()
        closeButton.setAttributedTitle(CandyComponents.underlinedAvenirAttributedString(withTitle: "Close"), for: .normal)
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { maker in
            maker.trailing.equalTo(card).inset(4)
            maker.top.equalTo(card).offset(4)
            maker.height.equalTo(20)
        }
        
        return titleLabel
    }
    
    private func buildButtons(withCardView card: UIView, label: UILabel) {
        let buttonMaker: (String) -> UIButton = { title in
            let button = UIButton()
            button.layer.cornerRadius = 5.0
            button.layer.borderWidth = 2.0
            button.layer.borderColor = UIColor.candyBackgroundBlue.cgColor
            
            button.titleLabel?.font = UIFont(name: "Avenir-black", size: 14)
            button.setTitle("ALLOW \(title)", for: .normal)
            button.setTitle("\(title) ALLOWED", for: .disabled)
            button.setTitleColor(.candyBackgroundBlue, for: .normal)
            button.setTitleColor(.white, for: .disabled)
            return button
        }
        
        let cameraButton = buttonMaker("CAMERA")
        cameraButton.rx.tap
            .subscribe(onNext: {
                self.listener?.requestCameraAccess()
            })
            .disposed(by: bag)
        let microphoneButton = buttonMaker("MICROPHONE")
        microphoneButton.rx.tap
            .subscribe(onNext: {
                self.listener?.requestMicrophoneAccess()
            })
            .disposed(by: bag)
        
        view.addSubview(cameraButton)
        view.addSubview(microphoneButton
        )
        cameraButton.snp.makeConstraints { maker in
            maker.height.equalTo(30)
            maker.leading.trailing.equalTo(card).inset(50)
            maker.top.equalTo(label.snp.bottom).offset(30)
        }
        
        microphoneButton.snp.makeConstraints { maker in
            maker.height.leading.trailing.equalTo(cameraButton)
            maker.top.equalTo(cameraButton.snp.bottom).offset(15)
        }
    }
}

