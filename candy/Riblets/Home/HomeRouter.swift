//
//  HomeRouter.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs

protocol HomeInteractable: Interactable, VideoChatListener, PermissionsListener, SettingsListener {
    var router: HomeRouting? { get set }
    var listener: HomeListener? { get set }
}

protocol HomeViewControllable: ViewControllable {
    // Declare methods the router invokes to manipulate the view hierarchy.
    func presentModally(viewController: ViewControllable)
    func dismissModally(viewController: ViewControllable)
}

final class HomeRouter: ViewableRouter<HomeInteractable, HomeViewControllable>, HomeRouting {

    // Constructor inject child builder protocols to allow building children.
    init(interactor: HomeInteractable,
                  viewController: HomeViewControllable,
                  videoChatBuilder: VideoChatBuildable,
                  permissionsBuilder: PermissionsBuildable,
                  settingsBuilder: SettingsBuildable) {
        
        self.videoChatBuilder = videoChatBuilder
        self.permissionsBuilder = permissionsBuilder
        self.settingsBuilder = settingsBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    // MARK: HomeRouting
    
    func routeToVideoChat(withRoomName roomName: String, roomToken: String, remoteUserFirstName: String) {
        let videoChat = videoChatBuilder.build(withListener: interactor,
                                               roomName: roomName,
                                               roomToken: roomToken,
                                               remoteUserFirstName: remoteUserFirstName)
        attachChild(videoChat)
        self.currentChild = videoChat
        viewController.presentModally(viewController: videoChat.viewControllable)
    }
    
    func routeToPermissions() {
        let permissions = permissionsBuilder.build(withListener: interactor)
        attachChild(permissions)
        self.currentChild = permissions
        viewController.presentModally(viewController: permissions.viewControllable)
    }
    
    func routeToHome() {
        detachCurrentChild()
    }
    
    func routeToSettings() {
        detachCurrentChild()
        
        let settings = settingsBuilder.build(withListener: interactor)
        attachChild(settings)
        self.currentChild = settings
        let navigationController = UINavigationController(root: settings.viewControllable)
        viewController.presentModally(viewController: navigationController)
    }
    
    // MARK: Private
    
    private let videoChatBuilder: VideoChatBuildable
    private let permissionsBuilder: PermissionsBuildable
    private let settingsBuilder: SettingsBuildable
    
    private var currentChild: ViewableRouting?
    
    private func detachCurrentChild() {
        guard let currentChild = currentChild else { return }
        detachChild(currentChild)
        self.currentChild = nil
        viewController.dismissModally(viewController: currentChild.viewControllable)
    }
}
