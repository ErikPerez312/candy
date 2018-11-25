//
//  EULARouter.swift
//  candy
//
//  Created by Erik Perez on 11/24/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs

protocol EULAInteractable: Interactable {
    var router: EULARouting? { get set }
    var listener: EULAListener? { get set }
}

protocol EULAViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class EULARouter: ViewableRouter<EULAInteractable, EULAViewControllable>, EULARouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: EULAInteractable, viewController: EULAViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
