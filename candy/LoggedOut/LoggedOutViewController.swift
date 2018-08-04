//
//  LoggedOutViewController.swift
//  candy
//
//  Created by Erik Perez on 8/3/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs
import RxSwift
import RxCocoa
import SnapKit
import UIKit

protocol LoggedOutPresentableListener: class {
    // Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func login(withPhoneNumber phoneNumber: String?, password: String?)
    func signUp()
}

final class LoggedOutViewController: UIViewController, LoggedOutPresentable, LoggedOutViewControllable {

    weak var listener: LoggedOutPresentableListener?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Method not supported")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .candyBackgroundPink
        navigationItem.titleView = CandyComponents.navigationBarTitleLabel(withTitle: "CANDY")
        
        let logoImageView = buildImageView()
        let textFields = buildTextFields(withImageView: logoImageView)
        buildButtons(withPhoneNumberField: textFields.phoneNumber, passwordField: textFields.password)
    }
    
    // MARK: - Private
    
    private let bag = DisposeBag()
    
    private func buildImageView() -> UIImageView {
        let logoImage = UIImage(named: "candy-logo") ?? nil
        let imageView = UIImageView(frame: .zero)
        imageView.image = logoImage
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints { maker in
            maker.top.equalTo(view.snp.topMargin).offset(20)
            maker.width.height.lessThanOrEqualTo(230).priority(1000)
            maker.centerX.equalTo(view.snp.centerX)
            maker.width.equalTo(imageView.snp.height).multipliedBy(1/1).priority(800)
        }
        return imageView
    }
    
    private func buildTextFields(withImageView imageView: UIImageView) -> (phoneNumber: UITextField, password: UITextField){
        let textFieldMaker: (String?) -> UITextField = { placeHolder in
            let textField = KaedeTextField(frame: .zero)
            textField.backgroundColor = .white
            textField.borderStyle = .roundedRect
            textField.placeholder = placeHolder ?? ""
            textField.delegate = self
            return textField
        }
        let phoneNumberTextField = textFieldMaker("Phone number")
        let passwordTextField = textFieldMaker("Password")
        
        view.addSubview(phoneNumberTextField)
        view.addSubview(passwordTextField)
        
        phoneNumberTextField.snp.makeConstraints { maker in
            maker.top.equalTo(imageView.snp.bottom).offset(20)
            maker.leading.trailing.equalTo(view).inset(32)
            maker.height.equalTo(45)
        }
        passwordTextField.snp.makeConstraints { maker in
            maker.top.equalTo(phoneNumberTextField.snp.bottom).offset(15)
            maker.leading.trailing.equalTo(phoneNumberTextField)
            maker.height.equalTo(phoneNumberTextField)
        }
        return (phoneNumberTextField, passwordTextField)
    }
    
    private func buildButtons(withPhoneNumberField phoneNumberField: UITextField, passwordField: UITextField) {
        let loginButton = UIButton(frame: .zero)
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = .candyBackgroundBlue
        loginButton.layer.cornerRadius = 6
        loginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.listener?.login(withPhoneNumber: phoneNumberField.text, password: passwordField.text)
            })
            .disposed(by: bag)
        
        let signUpButton = UIButton(frame: .zero)
        signUpButton.setAttributedTitle(CandyComponents.underlinedAvenirAttributedString(withTitle: "New user? Register here"), for: .normal)
        signUpButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.listener?.signUp()
            })
            .disposed(by: bag)
        
        view.addSubview(loginButton)
        view.addSubview(signUpButton)
        
        loginButton.snp.makeConstraints { maker in
            maker.top.equalTo(passwordField.snp.bottom).offset(20)
            maker.leading.trailing.equalTo(phoneNumberField)
            maker.height.equalTo(phoneNumberField)
        }
        signUpButton.snp.makeConstraints { maker in
            maker.top.equalTo(loginButton.snp.bottom).offset(30)
            maker.leading.trailing.equalTo(loginButton).inset(20)
            maker.height.equalTo(20).priority(1000)
            maker.bottom.lessThanOrEqualToSuperview().inset(50).priority(999)
        }
    }
}

extension LoggedOutViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("should animate")
    }
}
