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

protocol VideoChatPresentableListener: class, ChatTimerDelegate {
    // Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class VideoChatViewController: UIViewController, VideoChatPresentable, VideoChatViewControllable {

    weak var listener: VideoChatPresentableListener?
    
    override func viewDidLoad() {
        buildChatViews()
    }
    
    // MARK: - Private
    private var chatTimer: ChatTimer?
    
    private func buildChatViews() {
        let remoteUserView = TVIVideoView()
        remoteUserView.backgroundColor = .green
        view.addSubview(remoteUserView)
        remoteUserView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
        let localPreview = TVIVideoView()
        localPreview.backgroundColor = .gray
        localPreview.layer.cornerRadius = 8
        view.addSubview(localPreview)
        localPreview.snp.makeConstraints { maker in
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
}
