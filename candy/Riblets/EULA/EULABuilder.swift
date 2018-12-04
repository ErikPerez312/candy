//
//  EULABuilder.swift
//  candy
//
//  Created by Erik Perez on 11/24/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs

protocol EULADependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class EULAComponent: Component<EULADependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol EULABuildable: Buildable {
    func build(withListener listener: EULAListener) -> EULARouting
}

final class EULABuilder: Builder<EULADependency>, EULABuildable {

    override init(dependency: EULADependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: EULAListener) -> EULARouting {
        let component = EULAComponent(dependency: dependency)
        let viewController = EULAViewController()
        let interactor = EULAInteractor(presenter: viewController)
        interactor.listener = listener
        return EULARouter(interactor: interactor, viewController: viewController)
    }
}
