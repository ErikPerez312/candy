//
//  SettingsRouter.swift
//  candy
//
//  Created by Erik Perez on 10/29/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs

protocol SettingsInteractable: Interactable {
    var router: SettingsRouting? { get set }
    var listener: SettingsListener? { get set }
}

protocol SettingsViewControllable: ViewControllable {
    // Declare methods the router invokes to manipulate the view hierarchy.
}

final class SettingsRouter: ViewableRouter<SettingsInteractable, SettingsViewControllable>, SettingsRouting {

    // Constructor inject child builder protocols to allow building children.
    override init(interactor: SettingsInteractable, viewController: SettingsViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
