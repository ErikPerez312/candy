//
//  RootRouter.swift
//  candy
//
//  Created by Erik Perez on 8/3/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs

protocol RootInteractable: Interactable, LoggedOutListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func present(viewController: ViewControllable)
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: RootInteractable,
         viewController: RootViewControllable,
         loggedOutBuilder: LoggedOutBuildable) {
        
        self.loggedOutBuilder = loggedOutBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    override func didLoad() {
        let loggedOut = loggedOutBuilder.build(withListener: interactor)
        self.loggedOut = loggedOut
        
        attachChild(loggedOut)
        viewController.present(viewController: loggedOut.viewControllable)
    }
    
    // MARK: - Private
    
    private let loggedOutBuilder: LoggedOutBuildable
    private var loggedOut: ViewableRouting?
}
