//
//  VideoChatBuilder.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs

protocol VideoChatDependency: Dependency {
    // Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class VideoChatComponent: Component<VideoChatDependency> {
    // Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol VideoChatBuildable: Buildable {
    func build(withListener listener: VideoChatListener) -> VideoChatRouting
}

final class VideoChatBuilder: Builder<VideoChatDependency>, VideoChatBuildable {

    override init(dependency: VideoChatDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: VideoChatListener) -> VideoChatRouting {
        let _ = VideoChatComponent(dependency: dependency)
        let viewController = VideoChatViewController()
        let interactor = VideoChatInteractor(presenter: viewController)
        interactor.listener = listener
        return VideoChatRouter(interactor: interactor, viewController: viewController)
    }
}
