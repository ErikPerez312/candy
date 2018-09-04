//
//  PermissionsRouter.swift
//  candy
//
//  Created by Erik Perez on 8/27/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs

protocol PermissionsInteractable: Interactable {
    var router: PermissionsRouting? { get set }
    var listener: PermissionsListener? { get set }
}

protocol PermissionsViewControllable: ViewControllable {
    // Declare methods the router invokes to manipulate the view hierarchy.
}

final class PermissionsRouter: ViewableRouter<PermissionsInteractable, PermissionsViewControllable>, PermissionsRouting {
    // Constructor inject child builder protocols to allow building children.
    override init(interactor: PermissionsInteractable, viewController: PermissionsViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
