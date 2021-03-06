//
//  RegisterBuilder.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs

protocol RegisterDependency: Dependency {
    // Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class RegisterComponent: Component<RegisterDependency> {
    // Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol RegisterBuildable: Buildable {
    func build(withListener listener: RegisterListener) -> RegisterRouting
}

final class RegisterBuilder: Builder<RegisterDependency>, RegisterBuildable {

    override init(dependency: RegisterDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RegisterListener) -> RegisterRouting {
        let component = RegisterComponent(dependency: dependency)
        let viewController = RegisterViewController()
        let interactor = RegisterInteractor(presenter: viewController)
        interactor.listener = listener
        
        let eulaBuilder = EULABuilder(dependency: component)
        return RegisterRouter(interactor: interactor,
                              viewController: viewController,
                              eulaBuilder: eulaBuilder)
    }
}
