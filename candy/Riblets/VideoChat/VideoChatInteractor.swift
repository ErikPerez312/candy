//
//  VideoChatInteractor.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs
import RxSwift
import TwilioVideo

protocol VideoChatRouting: ViewableRouting {
    // Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol VideoChatPresentable: Presentable {
    // Declare methods the interactor can invoke the presenter to present data.
    
    var listener: VideoChatPresentableListener? { get set }
    
    func showLocalVideoTrack(_ videoTrack: TVIVideoTrack)
    func removeLocalVideoTrack(_ videoTrack: TVIVideoTrack)
    func showRemoteVideoTrack(_ videoTrack: TVIVideoTrack)
    func removeRemoteVideoTrack(_ videoTrack: TVIVideoTrack)
    func setUpCamera()
}

protocol VideoChatListener: class {
    // Declare methods the interactor can invoke to communicate with other RIBs.
    func callEnded()
}

final class VideoChatInteractor: PresentableInteractor<VideoChatPresentable>, VideoChatInteractable, VideoChatPresentableListener {
    
    weak var router: VideoChatRouting?
    weak var listener: VideoChatListener?

    // Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: VideoChatPresentable, roomName: String, roomToken: String) {
        self.roomName = roomName
        self.roomToken = roomToken
        self.twilioHandler = TwilioHandler(roomName: roomName, roomToken: roomToken)
        super.init(presenter: presenter)
        twilioHandler.delegate = self
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // Pause any business logic.
    }
    
    // MARK: VideoChatPresentableListener
    func shouldEndCall() {
        //TODO: should disconnect and dissmiss.
        twilioHandler.disconnectFromRoom()
        listener?.callEnded()
    }
    
    // MARK: ChatTimerDelegate
    
    func timerDidEnd() {
        print("timer did end")
        shouldEndCall()
//        twilioHandler.disconnectFromRoom()
//        listener?.callEnded()
    }
    
    // MARK: TwilioHandlerDelegate
    
    func addRenderer(forLocalVideoTrack videoTrack: TVIVideoTrack) {
        presenter.showLocalVideoTrack(videoTrack)
    }
    
    func removeRenderer(forLocalVideoTrack videoTrack: TVIVideoTrack) {
        presenter.removeLocalVideoTrack(videoTrack)
    }
    
    func addRenderer(forRemoteVideoTrack videoTrack: TVIVideoTrack) {
        presenter.showRemoteVideoTrack(videoTrack)
    }
    
    func removeRenderer(forRemoteVideoTrack videoTrack: TVIVideoTrack) {
        presenter.removeRemoteVideoTrack(videoTrack)
    }
    
    func didStartCapturingLocalCamera() {
        presenter.setUpCamera()
    }
    
    func disconnectedFromRoomWithError(_ error: Error?) {
        return
    }
    
    func roomConnectionFailed() {
        return
    }
    
    func remoteParticipantDidDisconnect() {
        shouldEndCall()
    }
    
    // MARK: - Private
    
    private var roomName: String
    private var roomToken: String
    private var twilioHandler: TwilioHandler
    
}

