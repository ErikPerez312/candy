//
//  RootInteractor.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs
import RxSwift

protocol RootRouting: ViewableRouting {
    // Declare methods the interactor can invoke to manage sub-tree via the router.
    func routeToHome()
    func routeToLoggedOut()
}

protocol RootPresentable: Presentable {
    // Declare methods the interactor can invoke the presenter to present data.
    var listener: RootPresentableListener? { get set }
}

protocol RootListener: class {
    // Declare methods the interactor can invoke to communicate with other RIBs.
}

final class RootInteractor: PresentableInteractor<RootPresentable>, RootInteractable, RootPresentableListener {

    weak var router: RootRouting?
    weak var listener: RootListener?

    // Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: RootPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        //  Implement business logic here.
        routeToInitialRib()
    }
    
    // MARK: LoggedOutListener
    
    func didLogin() {
        router?.routeToHome()
    }
    
    func didRegister() {
        router?.routeToHome()
    }
    
    // MARK: HomeListener
    
    func shouldRouteToLoggedOut() {
        router?.routeToLoggedOut()
    }
    
    // MARK: - Private
    
    private func routeToInitialRib() {
        guard UserDefaults.standard.bool(forKey: "isLoggedIn") else {
            router?.routeToLoggedOut()
            return
        }
        router?.routeToHome()
    }
}
