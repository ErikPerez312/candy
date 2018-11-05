//
//  SettingsViewController.swift
//  candy
//
//  Created by Erik Perez on 10/29/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import SnapKit
import Photos

protocol SettingsPresentableListener: class {
    // Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    
    func exitButtonPressed()
    func logout()
    func deleteProfile()
    func fetchProfileImage() -> UIImage?
    func uploadImage(_ imageInfo: [String:Any])
}

final class SettingsViewController: UIViewController, SettingsPresentable, SettingsViewControllable, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    weak var listener: SettingsPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .candyBackgroundPink
        setUpView()
        buildImagePicker()
        let settingViews = buildSettingsCardAndTitle()
        let firstNameLabel = buildUserInfoViews(withCard: settingViews.settingsCard, title: settingViews.title)
        buildOptionButtons(withCard: settingViews.settingsCard, firstNameLabel: firstNameLabel)
        profileImageView?.image = listener?.fetchProfileImage() ?? UIImage(named: "default-user")
        let firstName = UserDefaults.standard.value(forKey: "userFirstName") as? String ?? ""
        firstNameLabel.attributedText = CandyComponents.navigationBarTitleLabel(withTitle: firstName.uppercased()).attributedText
    }
    
    // MARK: SettingsPresentable
    
    func presentImagePicker() {
        guard let imagePicker = photoLibraryImagePicker else { return }
        present(imagePicker, animated: true, completion: nil)
    }
    
    func presentDeniedPermissionsAlert() {
        let settingsActionHandler: (UIAlertAction) -> Void = { _ in
            guard let settingsURL = URL(string: UIApplicationOpenSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
        let message = "In order for you to upload a profile picture, Candy needs access to your photo library. Please grant Candy access via settings."
        let alertController = UIAlertController(title: "Candy needs access", message: message, preferredStyle: .alert)
        let laterAction = UIAlertAction(title: "Later", style: .default, handler: nil)
        let settingsAction = UIAlertAction(title: "Go to settings", style: .default, handler: settingsActionHandler)
        alertController.addAction(settingsAction)
        alertController.addAction(laterAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentOkAlert(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentProfileImage(_ image: UIImage) {
        profileImageView?.image = image
    }
    
    func presentDeletingAccountActivityIndicator() {
        deleteAccountButton?.isEnabled = false
        deletingAccountActitvityIndicator?.isHidden = false
        deletingAccountActitvityIndicator?.startAnimating()
    }
    
    func hideDeletingAccountActivityIndicator() {
        deleteAccountButton?.isEnabled = true
        deletingAccountActitvityIndicator?.stopAnimating()
    }
    
    func presentProfileImageActivityIndicator() {
        print("\n * Will show profile indicaator")
        profileImageActivityIndicator?.isHidden = false
        profileImageActivityIndicator?.startAnimating()
    }
    
    func hideProfileImageActivityIndicator() {
        print("\n * Will hide profile indicaator")
        profileImageActivityIndicator?.stopAnimating()
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // FIXME: Bug when double tapping an image. Causes dismiss to be called twice
        // TODO: Create a handler for image picker
        listener?.uploadImage(info)
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private
    
    private var deleteAccountButton: UIButton?
    private var photoLibraryImagePicker: UIImagePickerController?
    private var profileImageView: UIImageView?
    private var deletingAccountActitvityIndicator: UIActivityIndicatorView?
    private var profileImageActivityIndicator: UIActivityIndicatorView?
    
    private func setUpView() {
        let navigationBar = navigationController?.navigationBar
        // Removes UINavigationBar bottom hairline
        navigationBar?.setValue(true, forKey: "hidesShadow")
        navigationBar?.barTintColor = view.backgroundColor
        navigationItem.titleView = CandyComponents.navigationBarTitleLabel(withTitle: "CANDY")
        
        let exitButton = UIBarButtonItem(image: UIImage(named: "exit-button"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(exitButtonPressed))
        exitButton.tintColor = .candyBackgroundBlue
        navigationItem.leftBarButtonItem = exitButton
    }
    
    private func buildSettingsCardAndTitle() -> (settingsCard: UIView, title: UILabel) {
        let card = UIView()
        card.layer.masksToBounds = false
        card.layer.cornerRadius = 16
        card.layer.shadowColor = UIColor.candyNavigationBarShadow.cgColor
        card.layer.shadowOffset = CGSize(width: 0, height: 0)
        card.layer.shadowRadius = CGFloat(38)
        card.layer.shadowOpacity = 1.0

        card.backgroundColor = .candyActivityCardBackground
        view.addSubview(card)
        card.snp.makeConstraints { maker in
            if UIScreen.main.bounds.height < 600 {
                // Screen sizes smaller than iPhone-8
                maker.height.equalTo(300)
            } else {
                maker.height.greaterThanOrEqualTo(400).priority(900)
            }
            maker.top.equalToSuperview().offset(140)
            maker.leading.trailing.equalToSuperview().inset(32)
        }
        
        let title = UILabel()
        title.textAlignment = .center
        title.attributedText = CandyComponents.navigationBarTitleLabel(withTitle: "SETTINGS").attributedText
        card.addSubview(title)
        title.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(20)
            maker.top.equalToSuperview().offset(17)
        }
        return (card, title)
    }
    
    /// Build profile image view and firstname label.
    /// - Returns: First name label
    private func buildUserInfoViews(withCard card: UIView, title: UILabel) -> UILabel {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 129, height: 129))
        self.profileImageView = imageView
        imageView.layer.borderWidth = 3
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.candyBackgroundBlue.cgColor
        imageView.layer.cornerRadius = imageView.frame.height/2
        
        imageView.image = UIImage(named: "default-user.png")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        card.addSubview(imageView)
        imageView.snp.makeConstraints { maker in
            maker.size.equalTo(CGSize(width: 129, height: 129))
            maker.centerX.equalToSuperview()
            maker.top.equalTo(card.snp.topMargin).offset(40)
        }
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.profileImageActivityIndicator = indicator
        indicator.isHidden = true
        imageView.addSubview(indicator)
        indicator.snp.makeConstraints { maker in
            maker.size.equalTo(CGSize(width: 40, height: 40))
            maker.center.equalToSuperview()
        }
        
        let firstNameLabel = UILabel()
        firstNameLabel.attributedText = CandyComponents.attributedString(title: "NAME")
        firstNameLabel.textAlignment = .center
        firstNameLabel.numberOfLines = 1
        
        card.addSubview(firstNameLabel)
        firstNameLabel.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(imageView.snp.bottomMargin).offset(10)
        }
        
        return firstNameLabel
    }
    
    private func buildOptionButtons(withCard card: UIView, firstNameLabel: UILabel) {
        let buttonMaker: (String) -> UIButton = { title in
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.layer.cornerRadius = 36 / 2
            button.backgroundColor = .candyBackgroundBlue
            button.setTitleColor(.white, for: .normal)
            card.addSubview(button)
            return button
        }
        
        let profilePictureButton = buttonMaker("Change Profile Picture")
        profilePictureButton.addTarget(self, action: #selector(changeProfilePictureButtonPressed), for: .touchUpInside)
        profilePictureButton.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(43)
            maker.top.equalTo(firstNameLabel).offset(25)
            maker.height.equalTo(36)
        }
        let logoutButton = buttonMaker("Logout")
        logoutButton.addTarget(self, action: #selector(logoutButtonPressed), for: .touchUpInside)
        logoutButton.snp.makeConstraints { maker in
            maker.height.leading.trailing.equalTo(profilePictureButton)
            maker.top.equalTo(profilePictureButton.snp.bottom).offset(11)
        }
        let deleteAccountButton = UIButton()
        self.deleteAccountButton = deleteAccountButton
        deleteAccountButton.setTitleColor(.white, for: .normal)
        deleteAccountButton.backgroundColor = .deletingRed
        deleteAccountButton.setTitle("Delete Account", for: .normal)
        deleteAccountButton.setTitle("", for: .disabled)
        deleteAccountButton.layer.cornerRadius = 36/2
        deleteAccountButton.addTarget(self, action: #selector(deleteAccountButtonPressed), for: .touchUpInside)
        
        card.addSubview(deleteAccountButton)
        deleteAccountButton.snp.makeConstraints { maker in
            maker.height.leading.trailing.equalTo(profilePictureButton)
            maker.top.equalTo(logoutButton.snp.bottom).offset(11)
            maker.bottom.equalToSuperview().inset(17).priority(900)
        }
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        self.deletingAccountActitvityIndicator = indicator
        deleteAccountButton.addSubview(indicator)
        indicator.snp.makeConstraints { maker in
            maker.size.equalTo(CGSize(width: 30, height: 30))
            maker.center.equalToSuperview()
        }
    }
    
    private func buildImagePicker() {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.delegate = self
        self.photoLibraryImagePicker = picker
    }
    
    @objc private func exitButtonPressed() {
        listener?.exitButtonPressed()
    }
    
    @objc private func changeProfilePictureButtonPressed() {
        presentImagePicker()
    }
    
    @objc private func logoutButtonPressed() {
        listener?.logout()
    }
    
    @objc private func deleteAccountButtonPressed() {
        let alertController = UIAlertController(title: "Are you sure you want to delete your account?", message: "This will permanently delete all your account data.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.listener?.deleteProfile()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        present(alertController, animated: true, completion: nil)
    }
}
