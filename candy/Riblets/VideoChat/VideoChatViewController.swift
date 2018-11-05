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
    
    weak var listener: VideoChatPresentableListener? {
        didSet {
            // 'listener' is nil at instantiation.
            // Set chatTimer delegate once we have a listener
            guard let interactor = listener else { return }
            chatTimer?.delegate = interactor
        }
    }
    
    init(remoteUserFirstName: String) {
        self.remoteUserFirstName = remoteUserFirstName
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .candyBackgroundPink
        buildWaitingForConnectionLabel()
        buildChatViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Method not supported")
    }
    
    // MARK: VideoChatPresentable
    
    func showLocalVideoTrack(_ videoTrack: TVIVideoTrack) {
        videoTrack.addRenderer(localUserView)
    }
    
    func showRemoteVideoTrack(_ videoTrack: TVIVideoTrack) {
        remoteUserView.isHidden = false
        videoTrack.addRenderer(remoteUserView)
        chatTimer?.startTimer()
    }
    
    func removeRemoteVideoTrack(_ videoTrack: TVIVideoTrack) {
        videoTrack.removeRenderer(remoteUserView)
    }
    
    // MARK: - Private
    
    private var remoteUserFirstName: String
    
    private var localUserView: TVIVideoView!
    private var remoteUserView: TVIVideoView!
    
    private var chatTimer: ChatTimer?
    private var questionsView: QuestionsView?
    private var waitingForConnectionLabel: UILabel?
    
    private func buildWaitingForConnectionLabel() {
        let label = UILabel()
        self.waitingForConnectionLabel = label
        label.numberOfLines = 4
        label.textAlignment = .center
        let title = "waiting for \(remoteUserFirstName) to connect".uppercased()
        label.attributedText = CandyComponents.navigationBarTitleLabel(withTitle: title).attributedText
        view.addSubview(label)
        label.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(10)
            maker.centerY.equalToSuperview()
        }
    }
    
    private func buildChatViews() {
        let remoteUserView = TVIVideoView()
        remoteUserView.contentMode = .scaleAspectFill
        remoteUserView.backgroundColor = .black
        remoteUserView.contentMode = .scaleAspectFill
        remoteUserView.isHidden = true
        self.remoteUserView = remoteUserView
        view.addSubview(remoteUserView)
        remoteUserView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
        let endCallGesture = UITapGestureRecognizer(target: self, action: #selector(localPreviewViewPressed))
        let localUserView = TVIVideoView()
        localUserView.shouldMirror = true
        localUserView.addGestureRecognizer(endCallGesture)
        localUserView.contentMode = .scaleAspectFill
        self.localUserView = localUserView
        localUserView.backgroundColor = .gray
        localUserView.layer.cornerRadius = 8
        view.addSubview(localUserView)
        localUserView.snp.makeConstraints { maker in
            maker.size.equalTo(CGSize(width: 130, height: 160))
            maker.top.equalTo(view.snp.topMargin)
            maker.leading.equalToSuperview().offset(8)
        }
        
        let nextQuestionGesture = UITapGestureRecognizer(target: self, action: #selector(questionsViewPressed))
        let questionsView = QuestionsView()
        self.questionsView = questionsView
        questionsView.addGestureRecognizer(nextQuestionGesture)
        view.addSubview(questionsView)
        questionsView.snp.makeConstraints { maker in
            maker.height.equalTo(70)
            maker.leading.trailing.equalToSuperview().inset(16)
            maker.bottom.equalToSuperview().inset(20)
        }
        
        let timer = ChatTimer()
        self.chatTimer = timer
        view.addSubview(timer)
        timer.snp.makeConstraints { maker in
            maker.width.height.equalTo(96)
            maker.bottom.equalTo(questionsView.snp.top).offset(-10)
            maker.trailing.equalToSuperview().inset(8)
        }
    }
    
    @objc private func localPreviewViewPressed() {
        listener?.shouldEndCall()
    }
    
    @objc private func questionsViewPressed() {
        questionsView?.updateQuestionLabel()
    }
}
