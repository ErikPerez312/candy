//
//  ReviewRouter.swift
//  candy
//
//  Created by Erik Perez on 12/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs

protocol ReviewInteractable: Interactable {
    var router: ReviewRouting? { get set }
    var listener: ReviewListener? { get set }
}

protocol ReviewViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ReviewRouter: ViewableRouter<ReviewInteractable, ReviewViewControllable>, ReviewRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ReviewInteractable, viewController: ReviewViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
