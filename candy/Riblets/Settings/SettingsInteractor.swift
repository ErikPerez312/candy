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
    func presentProfileImage(_ image: UIImage)
    func presentImagePicker()
    func presentDeletingAccountActivityIndicator()
    func hideDeletingAccountActivityIndicator()
    func presentProfileImageActivityIndicator()
    func hideProfileImageActivityIndicator()
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
        presenter.presentDeletingAccountActivityIndicator()
        guard let id = KeychainHelper.fetch(.userID) else { return }
        CandyAPI.deleteUser(withID: id) { (code) in
            DispatchQueue.main.async {
                self.presenter.hideDeletingAccountActivityIndicator()
            }
            guard let statusCode = code , statusCode == 204 else {
                DispatchQueue.main.async {
                    self.presenter.presentOkAlert(title: "Oops", message: "Something went wrong on our end. Please try again later")
                }
                return
            }
            print("Did delete")
            DispatchQueue.main.async {
                self.listener?.shouldRouteToLoggedOut()
            }
        }
    }
    
    func uploadImage(_ imageInfo: [String: Any]) {
        guard let imageURL = imageInfo[UIImagePickerControllerImageURL] as? URL,
            let image = imageInfo[UIImagePickerControllerOriginalImage] as? UIImage,
            let imageData = UIImagePNGRepresentation(image) else {
                DispatchQueue.main.async {
                    self.presenter.presentOkAlert(title: "Upload Failed", message: "Please try again")
                }
                return
        }
        
        presenter.presentProfileImageActivityIndicator()
        let candyImageInfo = CandyImageInfo(filename: imageURL.lastPathComponent, imageData: imageData)

        // Upload image to AWS
        CandyAPI.uploadProfileImage(withImageInfo: candyImageInfo) { (json, error) in
            DispatchQueue.main.async {
                self.presenter.hideProfileImageActivityIndicator()
            }
            guard let validJSON = json,
                let imageSourceURL = validJSON["url"] as? String else {
                    DispatchQueue.main.async {
                        self.presenter.presentOkAlert(title: "Upload Failed", message: "Please try again")
                    }
                    return
            }
            UserDefaults.standard.set(imageSourceURL, forKey: "profile-image-aws-url")
            self.cacheImage(image)
            DispatchQueue.main.async {
                self.presenter.presentProfileImage(image)
            }
        }
    }
    
    func fetchProfileImage() -> UIImage? {
        // Try to load image cache or download if cache is nil
        if let imageCacheURL = UserDefaults.standard.url(forKey: "profile-image") {
            print("\n * SettingsInteractor->fetchProfileImage: did Find URL For Local Image Cache")
            return UIImage(contentsOfFile: imageCacheURL.path)
        }
        
        if let imageAWSURL = UserDefaults.standard.value(forKey: "profile-image-aws-url") as? String {
            print("\n * SettingsInteractor->fetchProfileImage: did Find URL For aws Image Cache")
            presenter.presentProfileImageActivityIndicator()
            CandyAPI.downloadImage(withLink: imageAWSURL) { (image) in
                DispatchQueue.main.async {
                    self.presenter.hideProfileImageActivityIndicator()
                }
                guard let image = image else { return }
                DispatchQueue.main.async {
                    self.presenter.presentProfileImage(image)
                }
                self.cacheImage(image)
            }
        }
        return nil
    }
    
    // MARK: - Private
    
    private func cacheImage(_ image: UIImage) {
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
            print("file cant not be save at path \(filepath), with error : \(error)")
        }
    }
}
