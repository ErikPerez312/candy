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
import AVFoundation

protocol HomeRouting: ViewableRouting {
    // Declare methods the interactor can invoke to manage sub-tree via the router.
    func routeToVideoChat(withRoomName roomName: String, roomToken: String)
    func routeToHome()
    func routeToPermissions()
}

protocol HomePresentable: Presentable {
    // Declare methods the interactor can invoke the presenter to present data.
    var listener: HomePresentableListener? { get set }
    
    func presentAppearanceCount(_ count: Int)
    func updateActivityCard(withStatus status: ActivityCardStatus)
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
        setUpClient()
    }
    
    // MARK: HomePresentableListener
    
    func connect() {
        guard isRequiredMediaAccessGranted else {
            router?.routeToPermissions()
            return
        }
        presenter.updateActivityCard(withStatus: .connecting)
        appearanceChannel?.action("appear")
        chatChannel?.action("connect")
    }
    
    func canceledConnection() {
        appearanceChannel?.action("away")
        presenter.updateActivityCard(withStatus: .homeDefault)
    }
    
    func viewWillAppear() {
        addActiveApplicationObservers()
        presenter.updateActivityCard(withStatus: isActiveDay ? .homeDefault : .inactiveDay)
    }
    func viewWillDisappear() {
        removeActiveApplicationObservers()
    }
    
    func callEnded() {
        router?.routeToHome()
    }
    
    // MARK: PermissionsListener
    
    func shouldRouteToHome() {
        router?.routeToHome()
    }
    
    // MARK: - Private
    
    private var client: ActionCableClient?
    private var appearanceChannel: Channel?
    private var chatChannel: Channel?
    
    private var isRequiredMediaAccessGranted: Bool {
        // Authorization status checks shouldn't be dependencies created by parent
        // b/c an updated authorization status check is needed everytime.
        let cameraAccessStatus = AVCaptureDevice.authorizationStatus(for: .video)
        let microphoneAccessStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        return cameraAccessStatus == .authorized && microphoneAccessStatus == .authorized
    }
    
    private var isActiveDay: Bool {
        // TODO: Refactor - This should be done in backend to
        // prevent manual datetime change within settings.
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let currentDateString = dateFormatter.string(from: date)
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let time = hour - 12
        let isTimeValid = time >= 7 && time < 9
        
        return (currentDateString == "Friday" || currentDateString == "Saturday") && isTimeValid == true
    }
    
    private func setUpClient() {
        guard let userToken = KeychainHelper.fetch(.authToken) else {
            // TODO: If token not found, we should send to login screen
            return
        }
        let candyClient = ActionCableClient(url: CandyAPI.webSocketURL)
        self.client = candyClient
        candyClient.headers = ["Authorization": userToken]
        candyClient.origin = CandyAPI.webSocketOrigin
        candyClient.reconnectionStrategy = .linear(maxRetries: 5, intervalTime: 3)
        candyClient.connect()
        candyClient.onConnected = {
            self.buildAppearanceChannel(withClient: candyClient)
            self.buildChatChannel(withClient: candyClient)
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
        channel.onReceive = { (data: Any?, error: Error?) in
            guard let data = data,
                let appearanceDictionary = data as? [String: Int],
                let onlineCount = appearanceDictionary["online_user_count"],
                let availableCount = appearanceDictionary["online_available_user_count"] else {
                    return
            }
            self.presenter.presentAppearanceCount(onlineCount)
        }
    }
    
    private func buildChatChannel(withClient client: ActionCableClient) {
        let channel = client.create("ChatChannel")
        self.chatChannel = channel
        channel.onReceive = { [weak self] (data: Any?, error: Error?) in
            guard let data = data,
                let chatRoom = data as? [String: String],
                let roomName = chatRoom["room_name"],
                let token = chatRoom["twilio_token"] else {
                    return
            }
            self?.router?.routeToVideoChat(withRoomName: roomName, roomToken: token)
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
    }
    
    @objc private func applicationWillBecomeActive() {
        client?.connect()
    }
}
