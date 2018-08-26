//
//  HomeRouter.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs

protocol HomeInteractable: Interactable, VideoChatListener {
    var router: HomeRouting? { get set }
    var listener: HomeListener? { get set }
}

protocol HomeViewControllable: ViewControllable {
    // Declare methods the router invokes to manipulate the view hierarchy.
    func push(viewController: ViewControllable)
    func presentModally(viewController: ViewControllable)
    func dismissModally(viewController: ViewControllable)
}

final class HomeRouter: ViewableRouter<HomeInteractable, HomeViewControllable>, HomeRouting {

    // Constructor inject child builder protocols to allow building children.
    init(interactor: HomeInteractable,
                  viewController: HomeViewControllable,
                  videoChatBuilder: VideoChatBuildable) {
        
        self.videoChatBuilder = videoChatBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func routeToVideoChat(withRoomName roomName: String, roomToken: String) {
        let videoChat = videoChatBuilder.build(withListener: interactor,
                                               roomName: roomName,
                                               roomToken: roomToken)
        attachChild(videoChat)
        self.videoChat = videoChat
        viewController.presentModally(viewController: videoChat.viewControllable)
    }
    
    func routeToHome() {
        if let videoChat = videoChat {
            detachChild(videoChat)
            viewController.dismissModally(viewController: videoChat.viewControllable)
            self.videoChat = nil
        }
    }
    
    // MARK: Private
    
    private let videoChatBuilder: VideoChatBuildable
    
    private var videoChat: ViewableRouting?
    
}
