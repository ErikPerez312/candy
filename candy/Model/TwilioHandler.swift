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
    func addRenderer(forVideoTracks videoTracks: [TVIVideoTrack], audioTracks: [TVIAudioTrack])
    func removeRenderer(forVideoTrack videoTrack: TVIVideoTrack?, audioTrack: TVIAudioTrack?)
    
    func addRenderer(forRemoteVideoTrack videoTrack: TVIVideoTrack)
    func removeRenderer(forRemoteVideoTrack videoTrack: TVIVideoTrack)
    
    func didStartCapturingLocalCamera()
    func disconnectedFromRoomWithError(_ error: Error?)
    func remoteParticipantDidDisconnect()
}

class TwilioHandler: NSObject {
    
    weak var delegate: TwilioHandlerDelegate?
    
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
        let emptyLocalMedia = (videoTracks: [TVILocalVideoTrack](), audioTracks: [TVILocalAudioTrack]())
        let renderEmptyLocalMedia: () -> Void = { [weak self] in
            self?.delegate?.addRenderer(forVideoTracks: emptyLocalMedia.videoTracks,
                                        audioTracks: emptyLocalMedia.audioTracks)
        }
        let camera = TVICameraCapturer(source: .frontCamera, delegate: self)
        guard let frontCamera = camera else {
            renderEmptyLocalMedia()
            return emptyLocalMedia
        }
        
        guard let videoTrack = TVILocalVideoTrack(capturer: frontCamera, enabled: true, constraints: nil),
            let audioTrack = TVILocalAudioTrack(options: nil, enabled: true) else {
                renderEmptyLocalMedia()
                return emptyLocalMedia
        }
        delegate?.addRenderer(forVideoTracks: [videoTrack], audioTracks: [audioTrack])
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
        let videoTrack = remoteUser.videoTracks.first
        let audioTrack = remoteUser.audioTracks.first
        delegate?.removeRenderer(forVideoTrack: videoTrack, audioTrack: audioTrack)
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
        guard room.participants.count > 0 else { return }
        remoteUser = room.participants[0]
        remoteUser?.delegate = self
    }
    
    func room(_ room: TVIRoom, didDisconnectWithError error: Error?) {
        cleanupRemoteParticipant()
        delegate?.disconnectedFromRoomWithError(error)
        self.room = nil
    }
    
    func room(_ room: TVIRoom, participantDidConnect participant: TVIParticipant) {
        guard remoteUser == nil else { return }
        remoteUser = participant
        remoteUser?.delegate = self
    }
    
    func room(_ room: TVIRoom, participantDidDisconnect participant: TVIParticipant) {
        guard remoteUser == participant else { return }
        cleanupRemoteParticipant()
        //        chatTimer.endTimer()
        delegate?.remoteParticipantDidDisconnect()
    }
    
    func room(_ room: TVIRoom, didFailToConnectWithError error: Error) {
        self.room = nil
    }
}

extension TwilioHandler: TVICameraCapturerDelegate {
    func cameraCapturer(_ capturer: TVICameraCapturer, didStartWith source: TVICameraCaptureSource) {
        delegate?.didStartCapturingLocalCamera()
        //        localVideoPreviewView.shouldMirror = true
    }
}
