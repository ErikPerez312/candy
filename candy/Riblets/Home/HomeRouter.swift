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
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func push(viewController: ViewControllable)
    func presentModally(viewController: ViewControllable)
}

final class HomeRouter: ViewableRouter<HomeInteractable, HomeViewControllable>, HomeRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: HomeInteractable,
                  viewController: HomeViewControllable,
                  videoChatBuilder: VideoChatBuildable) {
        
        self.videoChatBuilder = videoChatBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func routeToVideoChat() {
        let videoChat = videoChatBuilder.build(withListener: interactor)
        attachChild(videoChat)
        viewController.presentModally(viewController: videoChat.viewControllable)
    }
    
    // MARK: Private
    
    private let videoChatBuilder: VideoChatBuildable
    
    private var currentChild: ViewableRouting?
    
}
