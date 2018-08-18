//
//  ChatTimer.swift
//  candy
//
//  Created by Erik Perez on 8/17/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import Foundation
import UIKit

// TODO: Refactor

protocol ChatTimerDelegate {
    func timerDidEnd()
}

class ChatTimer: UIView {
    // MARK: - Properties
    var delegate: ChatTimerDelegate?
    private var timer: Timer!
    private var totalTime = 120
    private var label: UILabel!
    
    // MARK: - Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        setUpLabel()
        addConstraintsToLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
        setUpLabel()
        addConstraintsToLabel()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(updateTime),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    func endTimer() {
        timer.invalidate()
        delegate?.timerDidEnd()
    }
    
    @objc private func updateTime() {
        label.text = "\(totalTime)"
        if totalTime == 0 {
            endTimer()
        }
        totalTime -= 1
    }
    
    private func setUpView() {
        layer.cornerRadius = 48
        backgroundColor = .candyBackgroundBlue
    }
    
    private func setUpLabel() {
        label = UILabel(frame: CGRect.zero)
        label.font = UIFont.init(name: "Avenir-Black", size: 36)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.text = "120"
        self.addSubview(label)
    }
    
    private func addConstraintsToLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
