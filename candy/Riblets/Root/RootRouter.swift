//
//  RootRouter.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs

protocol RootInteractable: Interactable, LoggedOutListener, HomeListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    // Declare methods the router invokes to manipulate the view hierarchy.
    func present(viewController: ViewControllable, animated: Bool)
    func dismiss(viewController: ViewControllable, animated: Bool)
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {

    // Constructor inject child builder protocols to allow building children.
    init(interactor: RootInteractable,
                  viewController: RootViewControllable,
                  loggedOutBuilder: LoggedOutBuildable,
                  homeBuilder: HomeBuildable) {
        
        self.loggedOutBuilder = loggedOutBuilder
        self.homeBuilder = homeBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    override func didLoad() {
        print("\n* didLoad Root *\n")
    }
    
    func routeToHome() {
        if let loggedOut = self.loggedOut {
            detachChild(loggedOut)
            self.loggedOut = nil
        }
        
        let home = homeBuilder.build(withListener: interactor)
        let navigationController = UINavigationController(root: home.viewControllable)
        attachChild(home)
        self.home = home
        viewController.present(viewController: navigationController, animated: true)
    }
    
    func routeToLoggedOut() {
        if let home = home {
            detachChild(home)
            viewController.dismiss(viewController: home.viewControllable, animated: true)
            self.home = nil
        }
        let loggedOut = loggedOutBuilder.build(withListener: interactor)
        attachChild(loggedOut)
        self.loggedOut = loggedOut
    }
    
    // MARK: - Private
    
    private let loggedOutBuilder: LoggedOutBuildable
    private let homeBuilder: HomeBuildable
    
    private var home: ViewableRouting?
    private var loggedOut: Routing?
}
