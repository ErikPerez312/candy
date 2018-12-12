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
    func routeToVideoChat(withRoomName roomName: String, roomToken: String, remoteUserFirstName: String)
    func routeToHome()
    func routeToPermissions()
    func routeToSettings()
}

protocol HomePresentable: Presentable {
    // Declare methods the interactor can invoke the presenter to present data.
    var listener: HomePresentableListener? { get set }
    
    func presentAppearanceCount(_ count: Int)
    func updateActivityCard(withStatus status: ActivityCardStatus, firstName: String?, imageName: String?)
}

protocol HomeListener: class {
    // Declare methods the interactor can invoke to communicate with other RIBs.
    func shouldRouteToLoggedOut()
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
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    // MARK: HomePresentableListener
    
    func connect() {
        guard isRequiredMediaAccessGranted else {
            router?.routeToPermissions()
            return
        }
        presenter.updateActivityCard(withStatus: .connecting, firstName: nil, imageName: nil)
        chatChannel?.action("connect")
    }
    
    func canceledConnection() {
        chatChannel?.action("cancel_connection")
        presenter.updateActivityCard(withStatus: .homeDefault, firstName: nil, imageName: nil)
    }
    
    func settingsbuttonPressed() {
        router?.routeToSettings()
    }
    
    func viewWillAppear() {
        addActiveApplicationObservers()
        presenter.updateActivityCard(withStatus: .homeDefault, firstName: nil, imageName: nil)
    }
    func viewWillDisappear() {
        removeActiveApplicationObservers()
    }
    
    func callEnded() {
        router?.routeToHome()
    }
    
    func startChatButtonPressed() {
        guard let roomName = chatRoomName,
            let roomToken = chatRoomToken,
            let firstName = remoteUserFirstName else { return }
        router?.routeToVideoChat(withRoomName: roomName, roomToken: roomToken, remoteUserFirstName: firstName)
    }
    
    func nextUserButtonPressed() {
        // User wants another user to chat with
        connect()
    }
    
    // MARK: PermissionsListener and SettingsListener
    
    func shouldRouteToHome() {
        router?.routeToHome()
    }
    
    // MARK: SettingsListener
    
    func shouldRouteToLoggedOut() {
        // Delete cached image. Fixes issue when signing into another account
        // and previous accounts profile image is loaded.
        User.clearCache()
        appearanceChannel?.unsubscribe()
        listener?.shouldRouteToLoggedOut()
    }
    
    // MARK: - Private
    
    private var chatRoomName: String?
    private var chatRoomToken: String?
    private var remoteUserFirstName: String?
    
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
        candyClient.onConnected = { [weak self] in
            self?.buildAppearanceChannel(withClient: candyClient)
            self?.buildChatChannel(withClient: candyClient)
        }
    }
    
    private func buildAppearanceChannel(withClient client: ActionCableClient) {
        let channel = client.create("AppearanceChannel")
        self.appearanceChannel = channel
        channel.onReceive = { [weak self] (data: Any?, error: Error?) in
            guard let data = data,
                let appearanceDictionary = data as? [String: Int],
                let onlineCount = appearanceDictionary["online_user_count"],
                let _ = appearanceDictionary["online_available_user_count"] else {
                    return
            }
            self?.presenter.presentAppearanceCount(onlineCount)
        }
    }
    
    private func buildChatChannel(withClient client: ActionCableClient) {
        let channel = client.create("ChatChannel")
        self.chatChannel = channel
        channel.onReceive = { [weak self] (data: Any?, error: Error?) in
            guard let data = data,
                let chatRoom = data as? [String: String],
                let roomName = chatRoom["room_name"],
                let token = chatRoom["twilio_token"],
                let _ = chatRoom["remote_user_id"],
                let remoteUserFirstName = chatRoom["remote_user_first_name"],
                let remoteUserProfileImageURL = chatRoom["remote_user_profile_image_url"] else {
                    return
            }
            print("\n * Chat room data", chatRoom)
            self?.chatRoomName = roomName
            self?.chatRoomToken = token
            self?.remoteUserFirstName = remoteUserFirstName
            self?.presenter.updateActivityCard(withStatus: .profileView,
                                               firstName: remoteUserFirstName.uppercased(),
                                               imageName: remoteUserProfileImageURL)
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
