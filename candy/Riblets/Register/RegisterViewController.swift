//
//  RegisterViewController.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import SnapKit
import RxCocoa

protocol RegisterPresentableListener: class {
    // Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class RegisterViewController: UIViewController, RegisterPresentable, RegisterViewControllable {

    weak var listener: RegisterPresentableListener?
    
    override func viewDidLoad() {
        view.backgroundColor = .candyBackgroundPink
        let cancelButton = buildCancelButton()
        let entryViews = buildQuestionEntryViews(withButton: cancelButton)
        let currentEntryLabel = buildProgessViews(withLabel: entryViews.questionLabel,
                                                  textField: entryViews.textField)
        buildConfirmationCodeViews(withLabel: currentEntryLabel)
    }
    
    // MARK: - Private
    
    private func buildCancelButton() -> UIButton {
        let button = UIButton(frame: .zero)
        button.setAttributedTitle(CandyComponents.underlinedAvenirAttributedString(withTitle: "Cancel"), for: .normal)
        view.addSubview(button)
        button.snp.makeConstraints { maker in
            maker.height.equalTo(20)
            maker.leading.equalToSuperview().inset(20)
            maker.trailing.lessThanOrEqualToSuperview().inset(100)
            maker.top.equalTo(view.snp.topMargin)
        }
        return button
    }
    
    private func buildQuestionEntryViews(withButton button: UIButton) -> (questionLabel: UILabel, textField: UITextField) {
        let label = UILabel(frame: .zero)
        label.textColor = .candyBackgroundBlue
        label.font = UIFont(name: "Avenir-Black", size: 22.0)!
        label.text = "Enter your phone number"
        view.addSubview(label)
        label.snp.makeConstraints { maker in
            maker.height.equalTo(label.font.pointSize + 5)
            maker.top.equalTo(button.snp.bottom).offset(40)
            maker.leading.trailing.equalToSuperview().inset(32)
        }
        
        let textField = UITextField(frame: .zero)
        textField.font = UIFont(name: "Avenir-Black", size: 25.0)
        textField.textColor = .candyBackgroundBlue
        textField.backgroundColor = .candyActivityCardBackground
        textField.rightViewMode = .always
        textField.contentVerticalAlignment = .center
        textField.textAlignment = .center
        
        let nextButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        nextButton.setImage(UIImage(named: "arrow"), for: .normal)
        nextButton.rx.tap
            .subscribe(onNext:{ [weak self] in
                
            })
        textField.rightView = nextButton
        view.addSubview(nextButton)
        view.addSubview(textField)
        textField.snp.makeConstraints { maker in
            maker.top.equalTo(label.snp.bottom).offset(10)
            maker.leading.trailing.equalTo(label)
            maker.height.equalTo(50)
        }
        return (label, textField)
    }
    
    private func buildProgessViews(withLabel label: UILabel, textField: UITextField) -> UILabel {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.trackTintColor = .candyNavigationBarShadow
        progressView.progressTintColor = .candyProgressBarPink
        progressView.setProgress(0.5, animated: true)
        view.addSubview(progressView)
        progressView.snp.makeConstraints { maker in
            maker.height.equalTo(6)
            maker.top.equalTo(textField.snp.bottom)
            maker.leading.trailing.equalTo(label)
        }
        
        let currentEntryCountLabel = UILabel(frame: .zero)
        currentEntryCountLabel.font = UIFont(name: "Avenir-Black", size: 13.0)!
        currentEntryCountLabel.text = "3/6"
        currentEntryCountLabel.textAlignment = .right
        currentEntryCountLabel.textColor = .black
        view.addSubview(currentEntryCountLabel)
        currentEntryCountLabel.snp.makeConstraints { maker in
            maker.height.equalTo(currentEntryCountLabel.font.pointSize + 5)
            maker.leading.trailing.equalTo(label)
            maker.top.equalTo(progressView.snp.bottom)
        }
        return currentEntryCountLabel
    }
    
    private func buildConfirmationCodeViews(withLabel label: UILabel) {
        let sendConfirmationCodeButton = UIButton(frame: .zero)
        sendConfirmationCodeButton.setTitle("Send Confirmation Code", for: .normal)
        sendConfirmationCodeButton.backgroundColor = .candyBackgroundBlue
        sendConfirmationCodeButton.layer.cornerRadius = 6
        view.addSubview(sendConfirmationCodeButton)
        sendConfirmationCodeButton.snp.makeConstraints { maker in
            maker.height.equalTo(45)
            maker.leading.trailing.equalTo(label)
            maker.top.equalTo(label).offset(40)
        }
        
        let disclaimer = UILabel(frame: .zero)
        disclaimer.numberOfLines = 4
        disclaimer.font = UIFont.systemFont(ofSize: 12)
        disclaimer.textAlignment = .center
        disclaimer.text = "We will text a verification code to this number to verify your identity. SMS fees may apply."
        view.addSubview(disclaimer)
        disclaimer.snp.makeConstraints { maker in
            maker.top.equalTo(sendConfirmationCodeButton.snp.bottom).offset(10)
            maker.bottom.lessThanOrEqualToSuperview().priority(999)
            maker.leading.trailing.equalTo(label)
        }
    }
}
