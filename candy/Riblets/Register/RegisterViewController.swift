//
//  RegisterViewController.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import SnapKit
import RxCocoa

protocol RegisterPresentableListener: class {
    // Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func verifyUserEntry(forStatement statement: Statement?, entry: String?)
    func verifyVerificationCode(_ code: String?)
    func cancelRegistration()
    func resendVerificationCode()
}

final class RegisterViewController: UIViewController, RegisterPresentable, RegisterViewControllable {
    
    weak var listener: RegisterPresentableListener?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        // When instantiating these components in viewDidLoad(:), it causes viewDidLoad(:) to be called
        // after the interactors didBecomeActive(:). - Figure out why
        let cancelButton = buildCancelButton()
        let entryViews = buildQuestionEntryViews(withButton: cancelButton)
        let currentEntryLabel = buildProgessViews(withLabel: entryViews.questionLabel, textField: entryViews.textField)
        let verifyCodeButton = buildConfirmationCodeViews(withLabel: currentEntryLabel)
        buildActivityIndicator(withButton: verifyCodeButton)
        buildPickerView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Method not supported")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .candyBackgroundPink
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField?.becomeFirstResponder()
    }
    
    // MARK: RegisterPresentable
    
    func presentAlert(withTitle title: String, description: String?, handler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title, message: description, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: handler)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func present(statement: Statement, progress: Float) {
        let refreshInputView: () -> Void = {
            self.textField?.resignFirstResponder()
            self.textField?.becomeFirstResponder()
        }
        self.statement = statement
        self.questionLabel?.text = statement.statement
        
        verifyCodeButton?.isHidden = !(statement.key == .phoneVerification)
        verifyCodeButton?.isEnabled = statement.key == .phoneVerification
        disclaimerLabel?.isHidden = !(statement.key == .phoneVerification)
        disclaimerLabel?.isEnabled = statement.key == .phoneVerification
        resendCodeButton?.isHidden = !(statement.key == .phoneVerification)
        resendCodeButton?.isEnabled = statement.key == .phoneVerification
        progressView?.setProgress(progress, animated: true)
        
        textField?.text = ""
        textField?.tintColor = .candyBackgroundBlue
        textField?.isSecureTextEntry = statement.key == .password
        textField?.rightView?.isHidden = statement.key == .phoneVerification
        textField?.keyboardType = (statement.key == .phoneNumber || statement.key == .phoneVerification) ? .numberPad : .default
        if statement.key == .phoneNumber {
            refreshInputView()
        }
        if textField?.inputView != nil || statement.key == .phoneNumber {
            textField?.inputView = nil
            refreshInputView()
        }
        if statement.key == .age || statement.key == .gender || statement.key == .seeking {
            // Hides blinking text cursor
            textField?.tintColor = .clear
            textField?.inputView = pickerView
            refreshInputView()
            pickerView?.reloadAllComponents()
            pickerView?.selectRow(0, inComponent: 0, animated: true)
            textField?.text = statement.key.values?.first
        }
    }
    
    func showActivityIndicator() {
        verifyCodeButton?.isEnabled = false
        activityIndicator?.isHidden = false
        activityIndicator?.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicator?.stopAnimating()
        verifyCodeButton?.isEnabled = true
    }
    
    // MARK: - Private
    
    private let bag = DisposeBag()
    
    private var statement: Statement?
    
    private var questionLabel: UILabel?
    private var disclaimerLabel: UILabel?
    private var textField: UITextField?
    private var pickerView: UIPickerView?
    private var verifyCodeButton: UIButton?
    private var resendCodeButton: UIButton?
    private var activityIndicator: UIActivityIndicatorView?
    private var progressView: UIProgressView?
    
    private func buildCancelButton() -> UIButton {
        let button = UIButton(frame: .zero)
        button.setAttributedTitle(CandyComponents.underlinedAvenirAttributedString(withTitle: "Cancel"), for: .normal)
        button.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.textField?.resignFirstResponder()
                self?.listener?.cancelRegistration()
            })
            .disposed(by: bag)
        view.addSubview(button)
        button.snp.makeConstraints { maker in
            maker.height.equalTo(20)
            maker.leading.equalToSuperview().inset(20)
            maker.trailing.lessThanOrEqualToSuperview().inset(100)
            maker.top.equalTo(view.snp.topMargin)
        }
        return button
    }
    
    private func buildQuestionEntryViews(withButton button: UIButton) -> (questionLabel: UILabel, textField: UITextField) {
        let label = UILabel(frame: .zero)
        self.questionLabel = label
        label.textColor = .candyBackgroundBlue
        label.font = UIFont(name: "Avenir-Black", size: 22.0)!
        view.addSubview(label)
        label.snp.makeConstraints { maker in
            maker.height.equalTo(label.font.pointSize + 5)
            if UIScreen.main.bounds.height < 600 {
                // Screen sizes smaller than iPhone-8
                maker.top.equalTo(button.snp.bottom).offset(15)
            } else {
                maker.top.equalTo(button.snp.bottom).offset(40)
            }
            maker.leading.trailing.equalToSuperview().inset(32)
        }
        
        let textField = UITextField(frame: .zero)
        self.textField = textField
        textField.font = UIFont(name: "Avenir-Black", size: 25.0)
        textField.textColor = .candyBackgroundBlue
        textField.backgroundColor = .candyActivityCardBackground
        textField.rightViewMode = .always
        textField.contentVerticalAlignment = .center
        textField.textAlignment = .center
        
        let nextButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        nextButton.setImage(UIImage(named: "arrow"), for: .normal)
        nextButton.rx.tap
            .subscribe(onNext:{ [weak self] in
                self?.listener?.verifyUserEntry(forStatement: self?.statement, entry: textField.text)
            })
            .disposed(by: bag)
        textField.rightView = nextButton
        view.addSubview(nextButton)
        view.addSubview(textField)
        textField.snp.makeConstraints { maker in
            maker.top.equalTo(label.snp.bottom).offset(10)
            maker.leading.trailing.equalTo(label)
            maker.height.equalTo(50)
        }
        return (label, textField)
    }
    
    private func buildProgessViews(withLabel label: UILabel, textField: UITextField) -> UILabel {
        let progressView = UIProgressView(progressViewStyle: .bar)
        self.progressView = progressView
        progressView.trackTintColor = .candyNavigationBarShadow
        progressView.progressTintColor = .candyProgressBarPink
        progressView.setProgress(0.5, animated: true)
        view.addSubview(progressView)
        progressView.snp.makeConstraints { maker in
            maker.height.equalTo(6)
            maker.top.equalTo(textField.snp.bottom)
            maker.leading.trailing.equalTo(label)
        }
        
        let currentEntryCountLabel = UILabel(frame: .zero)
        currentEntryCountLabel.isHidden = true
        currentEntryCountLabel.font = UIFont(name: "Avenir-Black", size: 13.0)!
        currentEntryCountLabel.text = "3/6"
        currentEntryCountLabel.textAlignment = .right
        currentEntryCountLabel.textColor = .black
        view.addSubview(currentEntryCountLabel)
        currentEntryCountLabel.snp.makeConstraints { maker in
            maker.height.equalTo(currentEntryCountLabel.font.pointSize + 5)
            maker.leading.trailing.equalTo(label)
            maker.top.equalTo(progressView.snp.bottom)
        }
        return currentEntryCountLabel
    }
    
    private func buildConfirmationCodeViews(withLabel label: UILabel) -> UIButton {
        let verifyCodeButton = UIButton(frame: .zero)
        self.verifyCodeButton = verifyCodeButton
        verifyCodeButton.setTitle("Verify Code", for: .normal)
        verifyCodeButton.setTitle("", for: .disabled)
        verifyCodeButton.backgroundColor = .candyBackgroundBlue
        verifyCodeButton.layer.cornerRadius = 6
        verifyCodeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.listener?.verifyVerificationCode(self?.textField?.text)
            })
            .disposed(by: bag)
        view.addSubview(verifyCodeButton)
        verifyCodeButton.snp.makeConstraints { maker in
            maker.height.equalTo(45)
            maker.leading.trailing.equalTo(label)
            maker.top.equalTo(label).offset(40)
        }
        
        let disclaimer = UILabel(frame: .zero)
        self.disclaimerLabel = disclaimer
        disclaimer.numberOfLines = 4
        disclaimer.font = UIFont.systemFont(ofSize: 12)
        disclaimer.textAlignment = .center
        disclaimer.text = """
            We sent a verification code to this number to verify your identity. It can take up to 1 minute to receive.
            You can try to resend if it takes longer.
        """
        view.addSubview(disclaimer)
        disclaimer.snp.makeConstraints { maker in
            maker.top.equalTo(verifyCodeButton.snp.bottom).offset(10)
            maker.leading.trailing.equalTo(label)
        }
        
        let resendCodeButton = UIButton(frame: .zero)
        self.resendCodeButton = resendCodeButton
        resendCodeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.listener?.resendVerificationCode()
            })
            .disposed(by: bag)
        view.addSubview(resendCodeButton)
        resendCodeButton.setAttributedTitle(CandyComponents.underlinedAvenirAttributedString(withTitle: "Resend Code"), for: .normal)
                resendCodeButton.snp.makeConstraints { maker in
                    maker.height.equalTo(30)
                    maker.centerX.equalToSuperview()
                    maker.top.equalTo(disclaimer.snp.bottom).offset(15)
                    maker.bottom.lessThanOrEqualToSuperview().priority(999)
                }
        return verifyCodeButton
    }
    
    private func buildPickerView() {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        self.pickerView = picker
    }
    
    private func buildActivityIndicator(withButton button: UIButton) {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.activityIndicatorViewStyle = .white
        indicator.isHidden = true
        self.activityIndicator = indicator
        
        view.addSubview(indicator)
        indicator.snp.makeConstraints { maker in
            maker.centerX.centerY.equalTo(button)
        }
    }
}

extension RegisterViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let statement = statement else { return nil }
        return statement.key.values?[row] ?? nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField?.text = statement?.key.values?[row]
    }
}

extension RegisterViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let statement = statement else { return 0 }
        return statement.key.values?.count ?? 0
    }
}
