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
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RegisterPresentable: Presentable {
    var listener: RegisterPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol RegisterListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class RegisterInteractor: PresentableInteractor<RegisterPresentable>, RegisterInteractable, RegisterPresentableListener {

    weak var router: RegisterRouting?
    weak var listener: RegisterListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: RegisterPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
