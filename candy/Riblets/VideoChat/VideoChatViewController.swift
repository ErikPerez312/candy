//
//  VideoChatViewController.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import TwilioVideo

protocol VideoChatPresentableListener: ChatTimerDelegate, TwilioHandlerDelegate {
    // Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func shouldEndCall()
}

final class VideoChatViewController: UIViewController, VideoChatPresentable, VideoChatViewControllable {
    
    weak var listener: VideoChatPresentableListener?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        buildChatViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Method not supported")
    }
    
    override func viewDidLoad() {
//        buildChatViews()
    }
    
    func showLocalVideoTrack(_ videoTrack: TVIVideoTrack) {
        videoTrack.addRenderer(localUserView)
    }
    
    func removeLocalVideoTrack(_ videoTrack: TVIVideoTrack) {
        videoTrack.removeRenderer(localUserView)
    }
    
    func showRemoteVideoTrack(_ videoTrack: TVIVideoTrack) {
        videoTrack.addRenderer(remoteUserView)
        chatTimer?.startTimer()
    }
    
    func removeRemoteVideoTrack(_ videoTrack: TVIVideoTrack) {
        videoTrack.removeRenderer(remoteUserView)
    }
    
    func setUpCamera() {
        localUserView.shouldMirror = true
    }
    
    // MARK: - Private
    
    private var localUserView: TVIVideoView!
    private var remoteUserView: TVIVideoView!
    
    private var chatTimer: ChatTimer?
    
    private func buildChatViews() {
        let remoteUserView = TVIVideoView()
        self.remoteUserView = remoteUserView
        remoteUserView.backgroundColor = .green
        remoteUserView.contentMode = .scaleAspectFill
        view.addSubview(remoteUserView)
        remoteUserView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
        let localUserView = TVIVideoView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(localPreviewViewPressed))
        localUserView.addGestureRecognizer(tapGesture)
        self.localUserView = localUserView
        localUserView.backgroundColor = .gray
        localUserView.layer.cornerRadius = 8
        view.addSubview(localUserView)
        localUserView.snp.makeConstraints { maker in
            maker.size.equalTo(CGSize(width: 130, height: 160))
            maker.top.equalTo(view.snp.topMargin)
            maker.leading.equalToSuperview().offset(8)
        }
        
        let questionsView = QuestionsView()
        view.addSubview(questionsView)
        questionsView.snp.makeConstraints { maker in
            maker.height.equalTo(70)
            maker.leading.trailing.equalToSuperview().inset(16)
            maker.bottom.equalToSuperview().inset(20)
        }
        
        let timer = ChatTimer()
        view.addSubview(timer)
        timer.delegate = listener
        timer.snp.makeConstraints { maker in
            maker.width.height.equalTo(96)
            maker.bottom.equalTo(questionsView.snp.top).offset(-10)
            maker.trailing.equalToSuperview().inset(8)
        }
    }
    
    @objc private func localPreviewViewPressed() {
        listener?.shouldEndCall()
    }
}
