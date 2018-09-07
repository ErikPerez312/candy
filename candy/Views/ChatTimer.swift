//
//  ChatTimer.swift
//  candy
//
//  Created by Erik Perez on 8/17/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

protocol ChatTimerDelegate: class {
    func timerDidEnd()
}

class ChatTimer: UIView {
    
    weak var delegate: ChatTimerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        buildLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Message not supported")
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(updateTime),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    // MARK: - Private
    
    private var timer: Timer?
    private var totalTime = 120
    private var countDownLabel: UILabel?
    
    @objc private func updateTime() {
        countDownLabel?.text = "\(totalTime)"
        if totalTime == 0 {
            endTimer()
        }
        totalTime -= 1
    }
    
    private func endTimer() {
        timer?.invalidate()
        delegate?.timerDidEnd()
    }
    
    private func setUpView() {
        layer.cornerRadius = 48
        backgroundColor = .candyBackgroundBlue
    }
    
    private func buildLabel() {
        let label = UILabel()
        self.countDownLabel = label
        label.font = UIFont(name: "Avenir-Black", size: 36)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.text = "\(totalTime)"
        self.addSubview(label)
        
        label.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
}
