//
//  HomeBuilder.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs

protocol HomeDependency: HomeDependencyVideoChat, HomeDependencyPermissions, HomeDependencySettings {
    // Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class HomeComponent: Component<HomeDependency> {
    // Declare 'fileprivate' dependencies that are only used by this RIB.
    
}

// MARK: - Builder

protocol HomeBuildable: Buildable {
    func build(withListener listener: HomeListener) -> HomeRouting
}

final class HomeBuilder: Builder<HomeDependency>, HomeBuildable {

    override init(dependency: HomeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: HomeListener) -> HomeRouting {
        let component = HomeComponent(dependency: dependency)
        let viewController = HomeViewController()
        let interactor = HomeInteractor(presenter: viewController)
        let videoChatBuilder = VideoChatBuilder(dependency: component)
        let permissionsBuilder = PermissionsBuilder(dependency: component)
        let settingsBuilder = SettingsBuilder(dependency: component)
        
        interactor.listener = listener
        return HomeRouter(interactor: interactor,
                          viewController: viewController,
                          videoChatBuilder: videoChatBuilder,
                          permissionsBuilder: permissionsBuilder,
                          settingsBuilder: settingsBuilder)
    }
}
