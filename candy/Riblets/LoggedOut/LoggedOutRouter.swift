//
//  LoggedOutRouter.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs

protocol LoggedOutInteractable: Interactable, LoginListener, RegisterListener {
    var router: LoggedOutRouting? { get set }
    var listener: LoggedOutListener? { get set }
}

protocol LoggedOutViewControllable: ViewControllable {
    // Declare methods the router invokes to manipulate the view hierarchy. Since
    // this RIB does not own its own view, this protocol is conformed to by one of this
    // RIB's ancestor RIBs' view.
    func present(viewController: ViewControllable, animated: Bool)
    func dismiss(viewController: ViewControllable, animated: Bool)
}

final class LoggedOutRouter: Router<LoggedOutInteractable>, LoggedOutRouting {

    // Constructor inject child builder protocols to allow building children.
    init(interactor: LoggedOutInteractable,
         viewController: LoggedOutViewControllable,
         loginBuilder: LoginBuildable,
         registerBuilder: RegisterBuildable) {
        
        self.viewController = viewController
        self.loginBuilder = loginBuilder
        self.registerBuilder = registerBuilder
        super.init(interactor: interactor)
        interactor.router = self
    }
    
    override func didLoad() {
        attachLogin()
    }

    func cleanupViews() {
        // Since this router does not own its view, it needs to cleanup the views
        // it may have added to the view hierarchy, when its interactor is deactivated.
        if let currentChild = currentChild {
            viewController.dismiss(viewController: currentChild.viewControllable, animated: true)
        }
    }
    
    func routeToRegister() {
        detachCurrentChild()
        let register = registerBuilder.build(withListener: interactor)
        attachChild(register)
        currentChild = register
        viewController.present(viewController: register.viewControllable, animated: true)
    }
    
    func routeToLogin() {
        detachCurrentChild()
        attachLogin()
    }

    // MARK: - Private

    private let viewController: LoggedOutViewControllable
    private let loginBuilder: LoginBuildable
    private let registerBuilder: RegisterBuildable
    
    private var currentChild: ViewableRouting?
    
    private func attachLogin() {
        let login = loginBuilder.build(withListener: interactor)
        self.currentChild = login
        attachChild(login)
        viewController.present(viewController: login.viewControllable, animated: true)
    }
    
    private func detachCurrentChild() {
        if let currentChild = currentChild {
            detachChild(currentChild)
            self.currentChild = nil
            viewController.dismiss(viewController: currentChild.viewControllable, animated: true)
        }
    }
}
