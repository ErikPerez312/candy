//
//  SettingsInteractor.swift
//  candy
//
//  Created by Erik Perez on 10/29/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs
import RxSwift
import Photos

protocol SettingsRouting: ViewableRouting {
    // Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SettingsPresentable: Presentable {
    // Declare methods the interactor can invoke the presenter to present data.
    var listener: SettingsPresentableListener? { get set }
    
    func presentDeniedPermissionsAlert()
    func presentOkAlert(title: String, message: String?)
    func presentImagePicker()
}

protocol SettingsListener: class {
    // Declare methods the interactor can invoke to communicate with other RIBs.
    func shouldRouteToHome()
    func shouldRouteToLoggedOut()
}

final class SettingsInteractor: PresentableInteractor<SettingsPresentable>, SettingsInteractable, SettingsPresentableListener {

    weak var router: SettingsRouting?
    weak var listener: SettingsListener?

    // Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: SettingsPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    // MARK: SettingsPresentableLisener
    
    func exitButtonPressed() {
        listener?.shouldRouteToHome()
    }
    
    func logout() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        listener?.shouldRouteToLoggedOut()
    }
    
    func deleteProfile() {
        // TODO: Implement body
        return
    }
    
    func cacheImage(_ image: UIImage) {
        // TODO: Upload image to AWS
        
        let directoryPath =  NSHomeDirectory().appending("/Documents/")
        // Create documents directory if non-existant.
        if !FileManager.default.fileExists(atPath: directoryPath) {
            do {
                let documentDirectoryPath = NSURL.fileURL(withPath: directoryPath)
                try FileManager.default.createDirectory(at: documentDirectoryPath,
                                                        withIntermediateDirectories: true,
                                                        attributes: nil)
            } catch {
                print(error)
            }
        }
        // save image to file
        let filename = "profile-image.png"
        let filepath = directoryPath.appending(filename)
        let url = NSURL.fileURL(withPath: filepath)
        do {
            try UIImageJPEGRepresentation(image, 1.0)?.write(to: url, options: .atomic)
            UserDefaults.standard.set(url, forKey: "profile-image")
            print("did save")
            
        } catch {
            print("file cant not be save at path \(filepath), with error : \(error)");
        }
    }
    
    func fetchProfileImage() -> UIImage? {
        guard let imageURL = UserDefaults.standard.url(forKey: "profile-image") else { return nil }
        return UIImage(contentsOfFile: imageURL.path)
    }
}
