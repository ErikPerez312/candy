//
//  HomeViewController.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol HomePresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class HomeViewController: UIViewController, HomePresentable, HomeViewControllable {

    weak var listener: HomePresentableListener?
    
    override func viewDidLoad() {
        view.backgroundColor = .candyBackgroundPink
        // Removes UINavigationBar bottom hairline
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
}
