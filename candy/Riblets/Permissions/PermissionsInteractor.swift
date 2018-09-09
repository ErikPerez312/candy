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
    // Declare methods the interactor can invoke the presenter to present data.
    var listener: PermissionsPresentableListener? { get set }
    
    func presentAlert(withTitle title: String, message: String?)
    func presentDeniedPermissionsAlert(withTitle title: String, message: String?, handler: ((UIAlertAction) -> Void)?)
    func updateUIWithAuthorizationStatus(forCamera camera: AVAuthorizationStatus,
                                        microphone: AVAuthorizationStatus)
}

protocol PermissionsListener: class {
    // Declare methods the interactor can invoke to communicate with other RIBs.
    func shouldRouteToHome()
}

final class PermissionsInteractor: PresentableInteractor<PermissionsPresentable>, PermissionsInteractable, PermissionsPresentableListener {

    weak var router: PermissionsRouting?
    weak var listener: PermissionsListener?

    // Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: PermissionsPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
        presenter.updateUIWithAuthorizationStatus(forCamera: cameraAccessStatus, microphone: microphoneAccessStatus)
    }
    
    // MARK: PermissionsPresentableListener
    
    func requestAccess(forMediaType mediaType: AVMediaType) {
        let deniedAccessHandler: (UIAlertAction) -> Void = { _ in
            guard let settingsURL = URL(string: UIApplicationOpenSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
        let deniedAccessMessage = (mediaType == .audio) ? self.deniedMicrophoneAccessMessage : self.deniedCameraAccessMessage
        let mediaTypeString = (mediaType == .audio) ? "microphone" : "Camera"
        
        switch AVCaptureDevice.authorizationStatus(for: mediaType) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: mediaType) { (didAuthorize) in
                DispatchQueue.main.async {
                    self.presenter.updateUIWithAuthorizationStatus(forCamera: self.cameraAccessStatus,
                                                                  microphone: self.microphoneAccessStatus)
                }
                if !didAuthorize {
                    self.presenter.presentDeniedPermissionsAlert(withTitle: deniedAccessMessage,
                                                                 message: nil,
                                                                 handler: deniedAccessHandler)
                }
            }
        case .denied:
            self.presenter.presentDeniedPermissionsAlert(withTitle: deniedAccessMessage,
                                                         message: nil,
                                                         handler: deniedAccessHandler)
        case .restricted:
            self.presenter.presentAlert(withTitle: "Sorry, your device is restricted and can't grant \(mediaTypeString) access",
                                        message: nil)
        case .authorized:
            return
        }
        
    }
    
    func didPressCloseButton() {
        listener?.shouldRouteToHome()
    }
    
    // MARK: - Private
    
    // Authorization status checks shouldn't be dependencies created by parent
    // b/c an updated authorization status check is needed everytime.
    private var cameraAccessStatus: AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: .video)
    }
    private var microphoneAccessStatus: AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: .audio)
    }
    
    private let deniedCameraAccessMessage = "Candy needs camera access to allow you to video chat. You can allow Candy camera access in the apps settings."
    private let deniedMicrophoneAccessMessage = "Candy needs microphone access to allow you to video chat. You can allow Candy microphone access in the apps settings."
}
