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
}

protocol RegisterPresentable: Presentable {
    // Declare methods the interactor can invoke the presenter to present data.
    var listener: RegisterPresentableListener? { get set }
    
    func presentAlert(withTitle title: String, description: String?)
    func present(statement: Statement)
    func showActivityIndicator()
    func hideActivityIndicator()
}

protocol RegisterListener: class {
    // Declare methods the interactor can invoke to communicate with other RIBs.
    func didCancelRegistration()
}

final class RegisterInteractor: PresentableInteractor<RegisterPresentable>, RegisterInteractable, RegisterPresentableListener {
    
    weak var router: RegisterRouting?
    weak var listener: RegisterListener?

    // Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: RegisterPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
        print("\n* did init register interactor")
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        presenter.present(statement: statements[currentStatementIndex])
        print("\n* did activate register interactor")
    }

    override func willResignActive() {
        super.willResignActive()
        //  Pause any business logic.
        print("\n* did activate register interactor")
    }
    
    func verifyUserEntry(forStatement statement: Statement?, entry: String?) {
        guard let statement = statement else {
            presenter.presentAlert(withTitle: "Oops", description: "Something went wrong on our side")
            return
        }
        guard let entry = entry, !entry.isEmptyOrWhitespace else {
            presenter.presentAlert(withTitle: "Invalid Entry", description: "Can't be blank")
            return
        }
        
        switch statement.key {
        case .phoneNumber:
            if entry.count < 10 {
                presenter.presentAlert(withTitle: "Invalid Entry",
                                       description: "Please enter your 10 digit phone number")
                return
            }
            userEntries[statement.key.rawValue] = entry
            requestVerificationCode(withPhoneNumber: entry)
        case .age:
            guard let ageIntValue = Int(entry) else {
                presenter.presentAlert(withTitle: "Oops", description: "Something went wrong on our side")
                return
            }
            userEntries[statement.key.rawValue] = ageIntValue
        case .gender, .seeking:
            let genderIntValue = User.convertGenderToInt(entry)
            userEntries[statement.key.rawValue] = genderIntValue
        default:
            userEntries[statement.key.rawValue] = entry
        }
        currentStatementIndex += 1
        presenter.present(statement: statements[currentStatementIndex])
    }
    
    func requestVerificationCode(withPhoneNumber phoneNumber: String) {
        CandyAPI.requestVerificationCode(withPhoneNumber: phoneNumber, completionHandler: nil)
    }
    
    func verifyVerificationCode(_ code: String?) {
        guard let phoneNumber = userEntries["phoneNumber"] as? String else {
            presenter.presentAlert(withTitle: "Oops", description: "Something went wrong on our end.")
            return
        }
        guard let code = code, !code.isEmptyOrWhitespace else {
            presenter.presentAlert(withTitle: "Invalid Entry", description: "Code Can't be blank.")
            return
        }
        guard code.count == 5 else {
            presenter.presentAlert(withTitle: "Invalid Entry", description: "Please enter the 5 digit code.")
            return
        }
        presenter.showActivityIndicator()
        CandyAPI.verifyVerificationCode(withPhoneNumber: phoneNumber, code: code) { [weak self](json, error) in
            guard let json = json,
                let isVerified = json["success"] as? Bool else {
                    DispatchQueue.main.async {
                        self?.presenter.hideActivityIndicator()
                        self?.presenter.presentAlert(withTitle: "Oops", description: "Something went wrong on our end")
                    }
                return
            }
            if let errorObject = json["errors"] as? [String: String],
                let errorMessge = errorObject["message"], !isVerified {
                DispatchQueue.main.async {
                    self?.presenter.hideActivityIndicator()
                    self?.presenter.presentAlert(withTitle: errorMessge, description: nil)
                }
            }
        }
    }
    
    func cancelRegistration() {
        listener?.didCancelRegistration()
    }
    
    // MARK: - Private
    
    private var userEntries = [String: Any]()
    private let statements = Statement.registrationStatements
    private var currentStatementIndex = 0
}
