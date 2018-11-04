//
//  SettingsBuilder.swift
//  candy
//
//  Created by Erik Perez on 10/29/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs

protocol SettingsDependency: Dependency {
    // Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class SettingsComponent: Component<SettingsDependency> {
    // Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol SettingsBuildable: Buildable {
    func build(withListener listener: SettingsListener) -> SettingsRouting
}

final class SettingsBuilder: Builder<SettingsDependency>, SettingsBuildable {

    override init(dependency: SettingsDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SettingsListener) -> SettingsRouting {
        let _ = SettingsComponent(dependency: dependency)
        let viewController = SettingsViewController()
        let interactor = SettingsInteractor(presenter: viewController)
        interactor.listener = listener
        return SettingsRouter(interactor: interactor, viewController: viewController)
    }
}
