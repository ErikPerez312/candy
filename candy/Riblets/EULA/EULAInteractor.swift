//
//  EULAInteractor.swift
//  candy
//
//  Created by Erik Perez on 11/24/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs
import RxSwift

protocol EULARouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol EULAPresentable: Presentable {
    var listener: EULAPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol EULAListener: class {
    // Declare methods the interactor can invoke to communicate with other RIBs.
    func shouldDismiss()
}

final class EULAInteractor: PresentableInteractor<EULAPresentable>, EULAInteractable, EULAPresentableListener {

    weak var router: EULARouting?
    weak var listener: EULAListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: EULAPresentable) {
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
    
    // MARK: - EULAPresentableListener
    func shouldDismiss() {
        listener?.shouldDismiss()
    }
}
