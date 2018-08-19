//
//  HomeInteractor.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs
import RxSwift
import ActionCableClient

protocol HomeRouting: ViewableRouting {
    // Declare methods the interactor can invoke to manage sub-tree via the router.
    func routeToVideoChat()
}

protocol HomePresentable: Presentable {
    // Declare methods the interactor can invoke the presenter to present data.
    var listener: HomePresentableListener? { get set }
    
    func presentAppearanceCount(_ count: Int)
}

protocol HomeListener: class {
    // Declare methods the interactor can invoke to communicate with other RIBs.
}

final class HomeInteractor: PresentableInteractor<HomePresentable>, HomeInteractable, HomePresentableListener {

    weak var router: HomeRouting?
    weak var listener: HomeListener?

    // Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: HomePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // Implement business logic here.
        setUpClient()
    }

    override func willResignActive() {
        super.willResignActive()
        // Pause any business logic.
    }
    
    func connect() {
        // TODO: perform logic to connect with user
        router?.routeToVideoChat()
    }
    
    func canceledConnection() {
        print("canceled connce")
    }
    
    func viewWillAppear() {
        addActiveApplicationObservers()
    }
    func viewWillDisappear() {
        removeActiveApplicationObservers()
    }
    
    // MARK: - Private
    
    private var client: ActionCableClient?
    private var appearanceChannel: Channel?
    
    private func setUpClient() {
        guard let userToken = KeychainHelper.fetch(.authToken) else { return }
        let candyClient = ActionCableClient(url: CandyAPI.webSocketURL)
        self.client = candyClient
        candyClient.headers = ["Authorization": userToken]
        candyClient.origin = CandyAPI.webSocketOrigin
        candyClient.connect()
        candyClient.onConnected = {
            self.buildAppearanceChannel(withClient: candyClient)
        }
        candyClient.onDisconnected = { (error: ConnectionError?) in
            self.appearanceChannel?.action("away", with: nil)
        }
        candyClient.willReconnect = {
            return true
        }
    }
    
    private func buildAppearanceChannel(withClient client: ActionCableClient) {
        let channel = client.create("AppearanceChannel")
        self.appearanceChannel = channel
        channel.onReceive = { [weak self] (data: Any?, error: Error?) in
            guard let data = data,
                let appearanceDictionary = data as? [String: Int],
                let onlineCount = appearanceDictionary["online_user_count"],
                let availableCount = appearanceDictionary["online_available_user_count"] else {
                    return
            }
            self?.presenter.presentAppearanceCount(onlineCount)
            print("\n ****** OnlineCount: \(onlineCount), AvailableCount: \(availableCount)")
        }
    }
    
    private func addActiveApplicationObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillResignActive),
                                               name: NSNotification.Name.UIApplicationWillResignActive,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillBecomeActive),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive,
                                               object: nil)
    }
    private func removeActiveApplicationObservers() {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIApplicationWillResignActive,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIApplicationDidBecomeActive,
                                                  object: nil)
    }
    
    @objc private func applicationWillResignActive() {
        client?.disconnect()
//        updateActivityCardUI()
    }
    
    @objc private func applicationWillBecomeActive() {
        client?.connect()
    }
}
