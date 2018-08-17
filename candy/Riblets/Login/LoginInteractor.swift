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

protocol LoginPresentable: Presentable {
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

    override func didBecomeActive() {
        super.didBecomeActive()
        // Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // Pause any business logic.
    }
    
    func login(withPhoneNumber phoneNumber: String?, password: String?) {
        print("\n-Attempted Login with phone: \(phoneNumber) and pass: \(password) ")
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
                    self.presenter.presentAlert(withTitle: "Invalid Password",
                                                 description: "Password can not be blank.")
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
            if let user = User(json: validJSON) {
                print("Successful login with user: \(user.description)")
                self?.cacheUser(user)
                self?.listener?.didLogin()
            } else {
                let title = validJSON["error"] as? String ?? "Oops, Something went wrong."
                DispatchQueue.main.async {
                    self?.presenter.presentAlert(withTitle: title, description: nil)
                }
            }
        }
    }
    
    func register() {
        print("Should signup")
        listener?.register()
    }
    
    // MARK: - Private
    
    private func cacheUser(_ user: User) {
        KeychainHelper.save(value: user.token, as: .authToken)
        let userFileURL = cachedFileURL("user.plist")
        user.dictionary.write(to: userFileURL, atomically: true)
    }
    
    private func cachedFileURL(_ fileName: String) -> URL {
        return FileManager.default
            .urls(for: .cachesDirectory, in: .allDomainsMask)
            .first!
            .appendingPathComponent(fileName)
    }
}
