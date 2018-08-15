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
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func cleanupViews()
    func routeToRegister()
    func routeToLogin()
}

protocol LoggedOutListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func didLogin()
}

final class LoggedOutInteractor: Interactor, LoggedOutInteractable {

    weak var router: LoggedOutRouting?
    weak var listener: LoggedOutListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init() {}

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()

        router?.cleanupViews()
        // TODO: Pause any business logic.
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
}
