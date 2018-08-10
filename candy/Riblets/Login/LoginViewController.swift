//
//  LoginViewController.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs
import RxSwift
import RxCocoa
import SnapKit
import UIKit

protocol LoginPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    
    func login(withPhoneNumber phoneNumber: String?, password: String?)
    func register()
}

final class LoginViewController: UIViewController, LoginPresentable, LoginViewControllable {
    
    weak var listener: LoginPresentableListener?
    
    override func viewDidLoad() {
        view.backgroundColor = .candyBackgroundPink
        let imageView = buildImageView()
        let textFields = buildTextFields(withImageView: imageView)
        let loginButton = buildButtons(withPhoneNumberField: textFields.phoneNumber,
                                         passwordField: textFields.password)
        buildActivityIndicator(withButton: loginButton)
//        showActivityInidicator()
    }
    
    deinit {
        print("\n* deinitialized Login ViewController*\n")
    }
    
    func present(viewController: ViewControllable, animated: Bool) {
        self.present(viewController.uiviewController, animated: animated) {
            print("\n* did present alert controller *\n")
        }
    }
    
    func dismiss(viewController: ViewControllable, animated: Bool) {
        self.dismiss(animated: animated) {
            print("\n* did dismiss alert controller *\n")
        }
    }
    
    func presentAlert(withTitle title: String, description: String?) {
        let alertController = UIAlertController(title: title, message: description, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showActivityInidicator() {
        loginButton?.isEnabled = false
        activityIndicator?.isHidden = false
        activityIndicator?.startAnimating()
    }
    
    func hideActivityInidicator() {
        activityIndicator?.stopAnimating()
        loginButton?.isEnabled = true
    }
    
    // MARK: - Private
    
    private let bag = DisposeBag()
    private var activityIndicator: UIActivityIndicatorView?
    private var loginButton: UIButton?
    
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
    
    private func buildButtons(withPhoneNumberField phoneNumberField: UITextField,
                              passwordField: UITextField) -> UIButton {
        let loginButton = UIButton(frame: .zero)
        self.loginButton = loginButton
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitle("", for: .disabled)
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
                self?.listener?.register()
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
        return loginButton
    }
    
    private func buildActivityIndicator(withButton button: UIButton) {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.activityIndicatorViewStyle = .white
        indicator.isHidden = true
        self.activityIndicator = indicator
        
        view.addSubview(indicator)
        indicator.snp.makeConstraints { maker in
            maker.centerX.centerY.equalTo(button)
        }
    }
}
