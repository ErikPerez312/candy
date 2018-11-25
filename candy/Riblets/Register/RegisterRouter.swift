//
//  RegisterRouter.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs

protocol RegisterInteractable: Interactable, EULAListener {
    var router: RegisterRouting? { get set }
    var listener: RegisterListener? { get set }
}

protocol RegisterViewControllable: ViewControllable {
    // Declare methods the router invokes to manipulate the view hierarchy.
    func present(viewController: ViewControllable)
    func dismiss(viewController: ViewControllable)
}

final class RegisterRouter: ViewableRouter<RegisterInteractable, RegisterViewControllable>, RegisterRouting {

    // Constructor inject child builder protocols to allow building children.
    init(interactor: RegisterInteractable,
         viewController: RegisterViewControllable,
         eulaBuilder: EULABuildable) {
        
        self.eulaBuilder = eulaBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func routeToTermsAndConditions() {
        let eula = eulaBuilder.build(withListener: interactor)
        attachChild(eula)
        self.currentChild = eula
        let navigationController = UINavigationController(root: eula.viewControllable)
        viewController.present(viewController: navigationController)
    }
    
    // MARK: RegisterRouting
    func routeToRegister() {
        detachCurrentChild()
    }
    
    // MARK: - Private
    
    private var eulaBuilder: EULABuildable
    
    private var currentChild: ViewableRouting?
    
    private func detachCurrentChild() {
        guard let currentChild = currentChild else { return }
        detachChild(currentChild)
        self.currentChild = nil
        viewController.dismiss(viewController: currentChild.viewControllable)
    }
}
