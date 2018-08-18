//
//  HomeInteractor.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs
import RxSwift

protocol HomeRouting: ViewableRouting {
    // Declare methods the interactor can invoke to manage sub-tree via the router.
    func routeToVideoChat()
}

protocol HomePresentable: Presentable {
    var listener: HomePresentableListener? { get set }
    // Declare methods the interactor can invoke the presenter to present data.
}

protocol HomeListener: class {
    // Declare methods the interactor can invoke to communicate with other RIBs.
}

final class HomeInteractor: PresentableInteractor<HomePresentable>, HomeInteractable, HomePresentableListener {

    weak var router: HomeRouting?
    weak var listener: HomeListener?

    // Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: HomePresentable) {
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
    
    func connect() {
        // TODO: perform logic to connect with user
        router?.routeToVideoChat()
    }
    
    func canceledConnection() {
        print("canceled connce")
    }
}
