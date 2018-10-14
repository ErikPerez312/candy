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
    func showRemoteVideoTrack(_ videoTrack: TVIVideoTrack)
    func removeRemoteVideoTrack(_ videoTrack: TVIVideoTrack)
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
    
    // MARK: VideoChatPresentableListener
    
    func shouldEndCall() {
        twilioHandler.disconnectFromRoom()
        listener?.callEnded()
    }
    
    // MARK: ChatTimerDelegate
    
    func timerDidEnd() {
        shouldEndCall()
    }
    
    // MARK: TwilioHandlerDelegate
    
    func addRenderer(forLocalVideoTrack videoTrack: TVIVideoTrack) {
        presenter.showLocalVideoTrack(videoTrack)
    }
    
    func addRenderer(forRemoteVideoTrack videoTrack: TVIVideoTrack) {
        presenter.showRemoteVideoTrack(videoTrack)
    }
    
    func removeRenderer(forRemoteVideoTrack videoTrack: TVIVideoTrack) {
        presenter.removeRemoteVideoTrack(videoTrack)
    }
    
    func errorDidOcurr(withMessage message: String, error: Error?) {
        shouldEndCall()
    }
    
    func remoteParticipantDidDisconnect() {
        shouldEndCall()
    }
    
    // MARK: - Private
    
    private var roomName: String
    private var roomToken: String
    private var twilioHandler: TwilioHandler
}
