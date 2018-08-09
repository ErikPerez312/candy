//
//  RootViewController.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
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

final class RootViewController: UIViewController, RootPresentable, RootViewControllable {

    weak var listener: RootPresentableListener?
    
    override func viewDidLoad() {
        view.backgroundColor = .red
    }
    
    func present(viewController: ViewControllable, animated: Bool) {
        present(viewController.uiviewController, animated: animated, completion: nil)
    }
    
    func dismiss(viewController: ViewControllable, animated: Bool) {
        dismiss(animated: animated, completion: nil)
    }
}

extension RootViewController: LoggedOutViewControllable {
//    func present(viewController: ViewControllable, animated: Bool) {
//        present(viewController.uiviewController, animated: animated, completion: nil)
//    }
//
//    func dismiss(viewController: ViewControllable, animated: Bool) {
//        dismiss(animated: animated, completion: nil)
//    }
}

