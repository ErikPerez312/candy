//
//  QuestionsView.swift
//  candy
//
//  Created by Erik Perez on 8/17/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class QuestionsView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        buildLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Method not supported")
    }
    
    func updateQuestionLabel() {
        timerLabel?.text = questions.randomQuestion
    }
    
    // MARK: - Private
    
    private var timerLabel: UILabel?
    private let questions = Questions()
    
    private func setUpView() {
        layer.cornerRadius = 8
        backgroundColor = .candyBackgroundBlue
    }
    
    private func buildLabel() {
        let label = UILabel()
        self.timerLabel = label
        label.font = UIFont(name: "Avenir-Heavy", size: 13)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = questions.randomQuestion
        self.addSubview(label)
        
        label.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(10)
            maker.centerX.centerY.equalToSuperview()
        }
    }
}
