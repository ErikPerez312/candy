//
//  LoginInteractor.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs
import RxSwift

protocol LoginRouting: ViewableRouting {
    // Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol LoginPresentable: Presentable, UITextFieldDelegate {
    //  Declare methods the interactor can invoke the presenter to present data.
    var listener: LoginPresentableListener? { get set }
    
    func presentAlert(withTitle title: String, description: String?)
    func showActivityInidicator()
    func hideActivityInidicator()
}

protocol LoginListener: class {
    // Declare methods the interactor can invoke to communicate with other RIBs.
    func register()
    func didLogin()
}

final class LoginInteractor: PresentableInteractor<LoginPresentable>, LoginInteractable, LoginPresentableListener {

    weak var router: LoginRouting?
    weak var listener: LoginListener?

    // Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: LoginPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    func login(withPhoneNumber phoneNumber: String?, password: String?) {
        print("\n-Attempted Login with phone: \(phoneNumber ?? "none") and pass: \(password ?? "none") ")
        guard let number = phoneNumber,
            !number.isEmptyOrWhitespace,
            number.count == 10 else {
                DispatchQueue.main.async {
                    self.presenter.presentAlert(withTitle: "Invalid Phone Number",
                                           description: "Please enter your 10 digit phone number")
                }
                return
        }
        guard let password = password,
            !password.isEmptyOrWhitespace else {
                DispatchQueue.main.async {
                    self.presenter.presentAlert(withTitle: "Enter your password",
                                                 description: nil)
                }
                return
        }
        
        presenter.showActivityInidicator()
        CandyAPI.signIn(withPhoneNumber: number, password: password) { [weak self] json, error in
            DispatchQueue.main.async {
                self?.presenter.hideActivityInidicator()
            }
            guard error == nil,
                let validJSON = json else {
                    DispatchQueue.main.async {
                        self?.presenter.presentAlert(withTitle: "Oops, something went wrong",
                                                     description: "Please try again later")
                    }
                return
            }
            
            guard let user = User(json: validJSON) else {
                let title = validJSON["error"] as? String ?? "Oops, Something went wrong."
                DispatchQueue.main.async {
                    self?.presenter.presentAlert(withTitle: title, description: nil)
                }
                return
            }
            print("\n * Successful login with user: \n\(user.description) \n")
            self?.cacheUser(user)
            self?.listener?.didLogin()
        }
    }
    
    func register() {
        listener?.register()
    }
    
    // MARK: - Private
    
    private func cacheUser(_ user: User) {
        let userFileURL = FileManager.default
            .urls(for: .cachesDirectory, in: .allDomainsMask)
            .first!
            .appendingPathComponent("user.plist")
        KeychainHelper.save(value: user.token, as: .authToken)
        KeychainHelper.save(value: "\(user.id)", as: .userID)
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        let didSaveUserToFile = user.dictionary.write(to: userFileURL, atomically: true)
    }
}
