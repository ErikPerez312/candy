//
//  PermissionsBuilder.swift
//  candy
//
//  Created by Erik Perez on 8/27/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs
import AVFoundation

protocol PermissionsDependency: Dependency {
    // Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
    var cameraAccessStatus: AVAuthorizationStatus { get }
    var microphoneAccessStatus: AVAuthorizationStatus { get }
}

final class PermissionsComponent: Component<PermissionsDependency> {
    // Declare 'fileprivate' dependencies that are only used by this RIB.
    fileprivate var cameraAccessStatus: AVAuthorizationStatus {
        return dependency.cameraAccessStatus
    }
    
    fileprivate var microphoneAccessStatus: AVAuthorizationStatus {
        return dependency.microphoneAccessStatus
    }
}

// MARK: - Builder

protocol PermissionsBuildable: Buildable {
    func build(withListener listener: PermissionsListener) -> PermissionsRouting
}

final class PermissionsBuilder: Builder<PermissionsDependency>, PermissionsBuildable {

    override init(dependency: PermissionsDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: PermissionsListener) -> PermissionsRouting {
        let component = PermissionsComponent(dependency: dependency)
        let viewController = PermissionsViewController(cameraAccessStatus: component.cameraAccessStatus,
                                                       microphoneAccessStatus: component.microphoneAccessStatus)
        let interactor = PermissionsInteractor(presenter: viewController)
        interactor.listener = listener
        return PermissionsRouter(interactor: interactor, viewController: viewController)
    }
}
