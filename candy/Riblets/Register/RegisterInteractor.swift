//
//  RegisterInteractor.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs
import RxSwift

protocol RegisterRouting: ViewableRouting {
    // Declare methods the interactor can invoke to manage sub-tree via the router.
    func routeToTermsAndConditions()
    func routeToRegister()
}

protocol RegisterPresentable: Presentable {
    // Declare methods the interactor can invoke the presenter to present data.
    var listener: RegisterPresentableListener? { get set }
    
    func presentAlert(withTitle title: String, description: String?, handler: ((UIAlertAction) -> Void)?)
    func present(statement: Statement, progress: Float)
    func showActivityIndicator()
    func hideActivityIndicator()
}

protocol RegisterListener: class {
    // Declare methods the interactor can invoke to communicate with other RIBs.
    func didCancelRegistration()
    func didRegister()
}

final class RegisterInteractor: PresentableInteractor<RegisterPresentable>, RegisterInteractable, RegisterPresentableListener {
    
    weak var router: RegisterRouting?
    weak var listener: RegisterListener?

    // Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: RegisterPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        presenter.present(statement: statements[currentStatementIndex], progress: 0)
    }
    
    // MARK: RegisterPresentableListener
    
    func verifyUserEntry(forStatement statement: Statement?, entry: String?) {
        guard let statement = statement else {
            presenter.presentAlert(withTitle: "Oops", description: "Something went wrong on our side", handler: nil)
            return
        }
        guard let entry = entry, !entry.isEmptyOrWhitespace else {
            presenter.presentAlert(withTitle: "Invalid Entry", description: "Can't be blank", handler: nil)
            return
        }
        
        switch statement.key {
        case .phoneNumber:
            if entry.count != 10 {
                presenter.presentAlert(withTitle: "Invalid Entry",
                                       description: "Please enter your 10 digit phone number", handler: nil)
                return
            }
            userEntries[statement.key.rawValue] = entry
            requestVerificationCode(withPhoneNumber: entry)
        default:
            userEntries[statement.key.rawValue] = entry
        }
        currentStatementIndex += 1
        let progress = Float(currentStatementIndex) / Float(statements.count)
        presenter.present(statement: statements[currentStatementIndex], progress: progress)
    }
    
    func requestVerificationCode(withPhoneNumber phoneNumber: String) {
        CandyAPI.requestVerificationCode(withPhoneNumber: phoneNumber, completionHandler: nil)
    }
    
    func verifyVerificationCode(_ code: String?) {
        guard let phoneNumber = userEntries["phoneNumber"] as? String else {
            presenter.presentAlert(withTitle: "Oops", description: "Something went wrong on our end.", handler: nil)
            return
        }
        guard let code = code,
            !code.isEmptyOrWhitespace,
            code.count == 5 else {
            presenter.presentAlert(withTitle: "Invalid Entry", description: "Please enter the 5 digit code.", handler: nil)
            return
        }
        presenter.showActivityIndicator()
        CandyAPI.verifyVerificationCode(withPhoneNumber: phoneNumber, code: code) { [weak self] (json, error) in
            guard let json = json,
                let isVerified = json["success"] as? Bool else {
                    self?.defaultErrorAlertBehavior()
                return
            }
            if let errorObject = json["errors"] as? [String: String],
                let errorMessge = errorObject["message"],
                !isVerified {
                DispatchQueue.main.async {
                    self?.presenter.hideActivityIndicator()
                    self?.presenter.presentAlert(withTitle: errorMessge, description: nil, handler: nil)
                }
            }
            if isVerified {
                guard let userObject = self?.userEntries else {
                    self?.defaultErrorAlertBehavior()
                    return
                }
                self?.register(withUserObject: userObject)
            }
        }
    }
    
    func resendVerificationCode() {
        guard let phoneNumber = userEntries["phoneNumber"] as? String else {
            presenter.presentAlert(withTitle: "Oops", description: "Something went wrong on our side") { [weak self] _ in
                self?.presenter.listener?.cancelRegistration()
            }
            return
        }
        requestVerificationCode(withPhoneNumber: phoneNumber)
    }
    
    func cancelRegistration() {
        listener?.didCancelRegistration()
    }
    
    func showTermsandConditions() {
        router?.routeToTermsAndConditions()
    }
    
    // MARK: EULAListener
    func shouldDismiss() {
        router?.routeToRegister()
    }
    
    // MARK: - Private
    
    private var userEntries = [String: Any]()
    private let statements = Statement.registrationStatements
    private var currentStatementIndex = 0
    
    private func register(withUserObject userObject: [String: Any]) {
        CandyAPI.register(withUserDict: userObject) { [weak self] (json, error) in
            guard let json = json else {
                self?.defaultErrorAlertBehavior()
                return
            }
            // TODO: Find better solution. When a number is already registered,
            // a json response containing one key-value pair is returned. The key
            // is "phone_number". The value is "has already been taken".
            if json.count == 1 {
                DispatchQueue.main.async {
                    let errorDescription = "An account with that phone number already exists."
                    self?.presenter.hideActivityIndicator()
                    self?.presenter.presentAlert(withTitle: "Already Registered",
                                                 description: errorDescription) { _ in
                                                    self?.presenter.listener?.cancelRegistration()
                    }
                }
                return
            }
            guard let user = User(json: json) else {
                self?.defaultErrorAlertBehavior()
                return
            }
            print("\n* Successfully registered User: \n\(user.description)\n")
            // Clear cache first in case user deleted account and created another one.
            User.clearCache()
            user.cache()
            DispatchQueue.main.async {
                self?.presenter.hideActivityIndicator()
                self?.listener?.didRegister()
            }
        }
    }
    
    /// Stops activityIndicator animation and presents default UIAlert on main thread.
    private func defaultErrorAlertBehavior() {
        DispatchQueue.main.async { [weak self] in
            self?.presenter.hideActivityIndicator()
            self?.presenter.presentAlert(withTitle: "Oops", description: "Something went wrong on our end", handler: nil)
        }
    }
}
