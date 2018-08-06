//
//  VideoChatRouter.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs

protocol VideoChatInteractable: Interactable {
    var router: VideoChatRouting? { get set }
    var listener: VideoChatListener? { get set }
}

protocol VideoChatViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class VideoChatRouter: ViewableRouter<VideoChatInteractable, VideoChatViewControllable>, VideoChatRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: VideoChatInteractable, viewController: VideoChatViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
