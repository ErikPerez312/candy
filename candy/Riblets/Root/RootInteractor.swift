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
        print("\n* Running didBecomeActive(:) on RootInteractor")
        routeToInitialRib()
    }

    override func willResignActive() {
        super.willResignActive()
        // Pause any business logic.
    }
    
    func didLogin() {
        print("should route to logged in ")
        router?.routeToHome()
    }
    
    func didRegister() {
        print("\n* did Register in root Interactor ")
        router?.routeToHome()
    }
    
    // MARK: - Private
    
    private func routeToInitialRib() {
        guard let _ = KeychainHelper.fetch(.authToken) else {
            print("\n* Should route to LoggedOut")
            router?.routeToLoggedOut()
            return
        }
        print("\n* Should route to LoggedIn")
        router?.routeToHome()
    }
}
