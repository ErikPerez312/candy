//
//  ReviewInteractor.swift
//  candy
//
//  Created by Erik Perez on 12/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs
import RxSwift

protocol ReviewRouting: ViewableRouting {
    // Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ReviewPresentable: Presentable {
    var listener: ReviewPresentableListener? { get set }
    // Declare methods the interactor can invoke the presenter to present data.
}

protocol ReviewListener: class {
    // Declare methods the interactor can invoke to communicate with other RIBs.
    func closeReview()
}

final class ReviewInteractor: PresentableInteractor<ReviewPresentable>, ReviewInteractable, ReviewPresentableListener {

    weak var router: ReviewRouting?
    weak var listener: ReviewListener?

    // Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: ReviewPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    // MARK: - ReviewPresentableListener
    
    func closeButtonPressed() {
        listener?.closeReview()
    }
}
