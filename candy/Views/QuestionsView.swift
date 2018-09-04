//
//  QuestionsView.swift
//  candy
//
//  Created by Erik Perez on 8/17/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import Foundation
import UIKit

// TODO: Refactor

struct Questions {
    private let questions = [
        "Would you rather lose all of your money and valuables or all of the pictures you have ever taken?",
        "Would you rather your shirts be always two sizes too big or one size too small?",
        "Would you rather be alone for the rest of your life or always be surrounded by annoying people?",
        "Would you rather never use social media sites/apps again or never watch another movie/TV show?",
        "Would you rather be poor but help people or become incredibly rich by hurting people?",
        "Would you rather live without the internet or live without AC and heating?",
        "Would you rather find your true love or a suitcase with five million dollars inside?",
        "Would you rather be able to teleport anywhere or be able to read minds?",
        "Would you rather have unlimited sushi for life or unlimited tacos for life?",
        "Would you rather give up bathing for a month or give up the internet for a month?",
        "Would you rather relive the same day for 365 days or lose a year of your life?",
        "Would you rather be balding but fit or overweight with a full head of hair?",
        "Would you rather be an amazing painter or a brilliant mathematician?",
        "Would you rather be reincarnated as a fly or just cease to exist after you die?",
        "Would you rather lose the ability to read or lose the ability to speak?",
        "Would you rather lose your left hand or right foot?",
        "Would you rather face your fears or forget that you have them?",
        "Would you rather be forced to kill a kitten or kill a puppy?",
        "Would you rather find five dollars on the ground or find all of your missing socks?",
        "Would you rather eat an egg with a half formed chicken inside or eat five cooked cockroaches?",
        "Would you rather be unable to have kids or only be able to have twins?",
        "Would you rather have no eyebrows or only one eyebrow?",
        ]
    
    var randomQuestion: String {
        let questionsCount = UInt32(questions.count)
        let randomIndex = Int(arc4random_uniform(questionsCount))
        return questions[randomIndex]
    }
}

class QuestionsView: UIView {
    var label: UILabel!
    var questions = Questions()
    
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
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    private func setUpView() {
        layer.cornerRadius = 8
        backgroundColor = .candyBackgroundBlue
    }
    
    private func setUpLabel() {
        label = UILabel(frame: CGRect.zero)
        label.font = UIFont.init(name: "Avenir-Heavy", size: 13)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = questions.randomQuestion
        self.addSubview(label)
    }
    
    private func addConstraintsToLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10.0).isActive = true
        label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10.0).isActive = true
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
    }
    
    func updateQuestionLabel() {
        label.text = questions.randomQuestion
    }
}
