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
    
    init(dependency: VideoChatDependency, roomName: String, roomToken: String) {
        self.roomName = roomName
        self.roomToken = roomToken
        super.init(dependency: dependency)
    }
    
    fileprivate var roomName: String
    fileprivate var roomToken: String
}

// MARK: - Builder

protocol VideoChatBuildable: Buildable {
    func build(withListener listener: VideoChatListener,
               roomName: String,
               roomToken: String) -> VideoChatRouting
}

final class VideoChatBuilder: Builder<VideoChatDependency>, VideoChatBuildable {

    override init(dependency: VideoChatDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: VideoChatListener, roomName: String, roomToken: String) -> VideoChatRouting {
        let component = VideoChatComponent(dependency: dependency,
                                           roomName: roomToken,
                                           roomToken: roomToken)
        let viewController = VideoChatViewController()
        let interactor = VideoChatInteractor(presenter: viewController,
                                             roomName: component.roomName,
                                             roomToken: component.roomToken)
        interactor.listener = listener
        return VideoChatRouter(interactor: interactor, viewController: viewController)
    }
}
