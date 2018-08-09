//
//  VideoChatInteractor.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs
import RxSwift

protocol VideoChatRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol VideoChatPresentable: Presentable {
    var listener: VideoChatPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol VideoChatListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class VideoChatInteractor: PresentableInteractor<VideoChatPresentable>, VideoChatInteractable, VideoChatPresentableListener {

    weak var router: VideoChatRouting?
    weak var listener: VideoChatListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: VideoChatPresentable) {
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
