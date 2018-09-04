//
//  LoggedOutInteractor.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs
import RxSwift

protocol LoggedOutRouting: Routing {
    // Declare methods the interactor can invoke to manage sub-tree via the router.
    func cleanupViews()
    func routeToRegister()
    func routeToLogin()
}

protocol LoggedOutListener: class {
    // Declare methods the interactor can invoke to communicate with other RIBs.
    func didLogin()
    func didRegister()
}

final class LoggedOutInteractor: Interactor, LoggedOutInteractable {

    weak var router: LoggedOutRouting?
    weak var listener: LoggedOutListener?

    // Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init() {}

    override func willResignActive() {
        // Pause any business logic.
        super.willResignActive()
        router?.cleanupViews()
    }
    
    func register() {
        router?.routeToRegister()
    }
    
    func didLogin() {
        listener?.didLogin()
    }
    
    func didCancelRegistration() {
        router?.routeToLogin()
    }
    
    func didRegister() {
        listener?.didRegister()
    }
}
