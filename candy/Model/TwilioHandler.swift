//
//  TwilioHandler.swift
//  candy
//
//  Created by Erik Perez on 8/19/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import Foundation
import TwilioVideo

protocol TwilioHandlerDelegate: class {
    func addRenderer(forLocalVideoTrack videoTrack: TVIVideoTrack)
    func addRenderer(forRemoteVideoTrack videoTrack: TVIVideoTrack)
    func removeRenderer(forRemoteVideoTrack videoTrack: TVIVideoTrack)
    
    func errorDidOcurr(withMessage message: String, error: Error?)
    func remoteParticipantDidDisconnect()
}

final class TwilioHandler: NSObject {
    
    weak var delegate: TwilioHandlerDelegate? {
        didSet {
            // We only want to connect to chatroom once we have a delegate.
            guard let _ = delegate else { return }
            let localMedia = prepareLocalMedia()
            connectToRoom(withName: roomName, token: roomToken, localMedia: localMedia)
        }
    }
    
    init(roomName: String, roomToken: String) {
        self.roomName = roomName
        self.roomToken = roomToken
    }
    
    func disconnectFromRoom() {
        cleanUpRemoteParticipant()
        room?.disconnect()
    }
    
    // MARK: - Private
    
    private let roomName: String
    private let roomToken: String
    private var room: TVIRoom?
    private var remoteUser: TVIParticipant?
    
    private func prepareLocalMedia() -> (videoTracks: [TVILocalVideoTrack], audioTracks: [TVILocalAudioTrack]){
        let camera = TVICameraCapturer(source: .frontCamera, delegate: self)!
        guard let videoTrack = TVILocalVideoTrack(capturer: camera, enabled: true, constraints: nil),
            let audioTrack = TVILocalAudioTrack(options: nil, enabled: true) else {
                return ([TVILocalVideoTrack](), [TVILocalAudioTrack]())
        }
        delegate?.addRenderer(forLocalVideoTrack: videoTrack)
        return ([videoTrack], [audioTrack])
    }
    
    private func connectToRoom(withName name: String,
                               token: String,
                               localMedia: (videoTracks: [TVILocalVideoTrack], audioTracks: [TVILocalAudioTrack])) {
        
        let connectOptions = TVIConnectOptions(token: token) { builder in
            builder.audioTracks = localMedia.audioTracks
            builder.videoTracks = localMedia.videoTracks
            builder.roomName = name
        }
        self.room = TwilioVideo.connect(with: connectOptions, delegate: self)
    }
    
    private func cleanUpRemoteParticipant() {
        guard let remoteUser = remoteUser else { return }
        if let videoTrack = remoteUser.videoTracks.first {
            delegate?.removeRenderer(forRemoteVideoTrack: videoTrack)
        }
        self.remoteUser = nil
    }
    
}

// MARK: TVIParticipantDelegate

extension TwilioHandler: TVIParticipantDelegate {
    
    func participant(_ participant: TVIParticipant, addedVideoTrack videoTrack: TVIVideoTrack) {
        guard remoteUser == participant else {
            return
        }
        delegate?.addRenderer(forRemoteVideoTrack: videoTrack)
    }
    
    func participant(_ participant: TVIParticipant, removedVideoTrack videoTrack: TVIVideoTrack) {
        guard remoteUser == participant  else {
            return
        }
        delegate?.removeRenderer(forRemoteVideoTrack: videoTrack)
    }
}

// MARK: TVIRoomDelegate

extension TwilioHandler: TVIRoomDelegate {
    
    func didConnect(to room: TVIRoom) {
        // user joined participants room
        guard room.participants.count > 0 else { return }
        remoteUser = room.participants[0]
        remoteUser?.delegate = self
    }
    
    func room(_ room: TVIRoom, didFailToConnectWithError error: Error) {
        delegate?.errorDidOcurr(withMessage: "Failed to connect to room", error: error)
        self.room = nil
    }
    
    func room(_ room: TVIRoom, didDisconnectWithError error: Error?) {
        cleanUpRemoteParticipant()
        delegate?.errorDidOcurr(withMessage: "Disconnected from room", error: error)
        self.room = nil
    }
    
    func room(_ room: TVIRoom, participantDidConnect participant: TVIParticipant) {
        guard remoteUser == nil else { return }
        remoteUser = participant
        remoteUser?.delegate = self
    }
    
    func room(_ room: TVIRoom, participantDidDisconnect participant: TVIParticipant) {
        guard remoteUser == participant else { return }
        cleanUpRemoteParticipant()
        delegate?.remoteParticipantDidDisconnect()
    }
}

// MARK: TVICameraCapturerDelegate

extension TwilioHandler: TVICameraCapturerDelegate {
    
    func cameraCapturer(_ capturer: TVICameraCapturer, didStartWith source: TVICameraCaptureSource) {
        // Can customize camera here
    }
}
