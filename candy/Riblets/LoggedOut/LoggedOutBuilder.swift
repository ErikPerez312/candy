//
//  LoggedOutBuilder.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs

protocol LoggedOutDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but won't be
    // created by this RIB.
    var loggedOutViewController: LoggedOutViewControllable { get }
}

final class LoggedOutComponent: Component<LoggedOutDependency> {
    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
    
    fileprivate var loggedOutViewController: LoggedOutViewControllable {
        return dependency.loggedOutViewController
    }
}

// MARK: - Builder

protocol LoggedOutBuildable: Buildable {
    func build(withListener listener: LoggedOutListener) -> LoggedOutRouting
}

final class LoggedOutBuilder: Builder<LoggedOutDependency>, LoggedOutBuildable {

    override init(dependency: LoggedOutDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: LoggedOutListener) -> LoggedOutRouting {
        let component = LoggedOutComponent(dependency: dependency)
        let interactor = LoggedOutInteractor()
        let loginBuilder = LoginBuilder(dependency: component)
        let registerBuilder = RegisterBuilder(dependency: component)
        interactor.listener = listener
        return LoggedOutRouter(interactor: interactor,
                               viewController: component.loggedOutViewController,
                               loginBuilder: loginBuilder,
                               registerBuilder: registerBuilder)
    }
}

