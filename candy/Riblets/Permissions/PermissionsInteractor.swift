//
//  PermissionsInteractor.swift
//  candy
//
//  Created by Erik Perez on 8/27/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs
import RxSwift
import AVFoundation

protocol PermissionsRouting: ViewableRouting {
    // Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol PermissionsPresentable: Presentable {
    var listener: PermissionsPresentableListener? { get set }
    // Declare methods the interactor can invoke the presenter to present data.
}

protocol PermissionsListener: class {
    // Declare methods the interactor can invoke to communicate with other RIBs.
}

final class PermissionsInteractor: PresentableInteractor<PermissionsPresentable>, PermissionsInteractable, PermissionsPresentableListener {

    weak var router: PermissionsRouting?
    weak var listener: PermissionsListener?

    // Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: PermissionsPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // Pause any business logic.
    }
    
    // MARK: - PermissionsPresentableListener
    
    func requestCameraAccess() {
        return
    }
    
    func requestMicrophoneAccess() {
        return
    }
}
