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

protocol VideoChatPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class VideoChatViewController: UIViewController, VideoChatPresentable, VideoChatViewControllable {

    weak var listener: VideoChatPresentableListener?
    
    override func viewDidLoad() {
        view.backgroundColor = .green
    }
}
