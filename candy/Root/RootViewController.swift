//
//  RootViewController.swift
//  candy
//
//  Created by Erik Perez on 8/3/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol RootPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class RootViewController: UINavigationController, RootPresentable, RootViewControllable {

    weak var listener: RootPresentableListener?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Method not supported")
    }
    
    override func viewDidLoad() {
        // Hides Navigation Bar bottom hairline
        navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    // MARK: RootViewControllable
    
    func present(viewController: ViewControllable) {
        pushViewController(viewController.uiviewController, animated: true)
    }
}
