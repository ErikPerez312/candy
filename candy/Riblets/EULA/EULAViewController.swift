//
//  EULAViewController.swift
//  candy
//
//  Created by Erik Perez on 11/24/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import SnapKit

protocol EULAPresentableListener: class {
    // Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func shouldDismiss()
}

final class EULAViewController: UIViewController, EULAPresentable, EULAViewControllable {

    weak var listener: EULAPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        buildTextView()
    }
    
    // - MARK: Private
    
    private func setUpView() {
        let navigationBar = navigationController?.navigationBar
        // Removes UINavigationBar bottom hairline
        navigationBar?.setValue(true, forKey: "hidesShadow")
        navigationBar?.barTintColor = .candyBackgroundPink
        navigationItem.titleView = CandyComponents.navigationBarTitleLabel(withTitle: "CANDY")
        
        let exitButton = UIBarButtonItem(image: UIImage(named: "exit-button"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(exitButtonPressed))
        exitButton.tintColor = .candyBackgroundBlue
        navigationItem.leftBarButtonItem = exitButton
    }
    
    private func buildTextView() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        let textView = UITextView()
        view.addSubview(textView)
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let topBarHeight: CGFloat = navigationBar.frame.height + statusBarHeight
        let textViewHeight = view.frame.height - topBarHeight
        textView.frame = CGRect(x: 0, y: topBarHeight, width: view.frame.width, height: textViewHeight)
        textView.textAlignment = .natural
        textView.allowsEditingTextAttributes = false
        textView.text = CandyEULA.termsAndConditions
        textView.setContentOffset(.zero, animated: true)
    }
    
    @objc private func exitButtonPressed(sender: UIButton) {
        listener?.shouldDismiss()
    }
    
}
