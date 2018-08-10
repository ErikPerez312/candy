//
//  RegisterRouter.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs

protocol RegisterInteractable: Interactable {
    var router: RegisterRouting? { get set }
    var listener: RegisterListener? { get set }
}

protocol RegisterViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RegisterRouter: ViewableRouter<RegisterInteractable, RegisterViewControllable>, RegisterRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: RegisterInteractable, viewController: RegisterViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    override func didLoad() {
        print("\n* didLoad Register*\n")
    }
}