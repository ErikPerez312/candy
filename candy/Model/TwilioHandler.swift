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
    func removeRenderer(forLocalVideoTrack videoTrack: TVIVideoTrack)
    
    func addRenderer(forRemoteVideoTrack videoTrack: TVIVideoTrack)
    func removeRenderer(forRemoteVideoTrack videoTrack: TVIVideoTrack)
    
    func didStartCapturingLocalCamera()
    func disconnectedFromRoomWithError(_ error: Error?)
    func remoteParticipantDidDisconnect()
}

class TwilioHandler: NSObject {
    
    weak var delegate: TwilioHandlerDelegate? {
        didSet {
            guard let _ = delegate else { return }
            let localMedia = prepareLocalMedia()
            connectToRoom(withName: roomName, token: roomToken, localMedia: localMedia)
        }
    }
    
    var roomName: String
    var roomToken: String
    
    init(roomName: String, roomToken: String) {
        self.roomName = roomName
        self.roomToken = roomToken
    }
    
    // MARK: - Private
    
    private var room: TVIRoom?
    private var remoteUser: TVIParticipant?
    //    private var videoTrack: TVIVideoTrack?
    //    private var audioTrack: TVIAudioTrack?
    //    private var camera: TVICameraCapturer?
    
    private func prepareLocalMedia() -> (videoTracks: [TVILocalVideoTrack], audioTracks: [TVILocalAudioTrack]){
        let camera = TVICameraCapturer(source: .frontCamera, delegate: self)
        guard let videoTrack = TVILocalVideoTrack(capturer: camera!, enabled: true, constraints: nil),
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
    
    private func cleanupRemoteParticipant() {
        guard let remoteUser = remoteUser else {
            return
        }
        if let videoTrack = remoteUser.videoTracks.first {
            delegate?.removeRenderer(forRemoteVideoTrack: videoTrack)
        }
        self.remoteUser = nil
    }
    
}

extension TwilioHandler: TVIParticipantDelegate {
    public func participant(_ participant: TVIParticipant, addedVideoTrack videoTrack: TVIVideoTrack) {
        // Remote Participant has offered to share the video Track.
        guard remoteUser == participant else {
            return
        }
        delegate?.addRenderer(forRemoteVideoTrack: videoTrack)
    }
    
    public func participant(_ participant: TVIParticipant, removedVideoTrack videoTrack: TVIVideoTrack) {
        // Remote user stopped sharing the video track
        guard remoteUser == participant  else {
            return
        }
        delegate?.removeRenderer(forRemoteVideoTrack: videoTrack)
    }
    
    public func participant(_ participant: TVIParticipant, addedAudioTrack audioTrack: TVIAudioTrack) {
        // remote user offered to share the audio track
        //        guard remoteUser == participant  else { return }
    }
    
    public func participant(_ participant: TVIParticipant, removedAudioTrack audioTrack: TVIAudioTrack) {
        // remote user stoped sharing audio track
        //        guard remoteUser == participant  else { return }
    }
}

extension TwilioHandler: TVIRoomDelegate {
    func didConnect(to room: TVIRoom) {
        // user joined participants room
        print("\n *  did connect to room")
        guard room.participants.count > 0 else { return }
        remoteUser = room.participants[0]
        remoteUser?.delegate = self
    }
    
    func room(_ room: TVIRoom, didDisconnectWithError error: Error?) {
        print("TwilioHandlerError:", error)
        cleanupRemoteParticipant()
        delegate?.disconnectedFromRoomWithError(error)
        self.room = nil
    }
    
    func room(_ room: TVIRoom, participantDidConnect participant: TVIParticipant) {
        guard remoteUser == nil else { return }
        print("\n * participant did connect")
        remoteUser = participant
        remoteUser?.delegate = self
    }
    
    func room(_ room: TVIRoom, participantDidDisconnect participant: TVIParticipant) {
        guard remoteUser == participant else { return }
        cleanupRemoteParticipant()
        //        chatTimer.endTimer()
        room.disconnect()
        delegate?.remoteParticipantDidDisconnect()
    }
    
    func room(_ room: TVIRoom, didFailToConnectWithError error: Error) {
        print("TwilioHandlerError:", error)
        self.room = nil
    }
}

extension TwilioHandler: TVICameraCapturerDelegate {
    func cameraCapturer(_ capturer: TVICameraCapturer, didStartWith source: TVICameraCaptureSource) {
        delegate?.didStartCapturingLocalCamera()
        //        localVideoPreviewView.shouldMirror = true
    }
}
