//
//  SignUpViewController.swift
//  DemoThinkUp
//
//  Created by Diego Quimbo on 4/2/21.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {

    // IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var birthTextField: UITextField!
    
    @IBOutlet weak var nameErrorLabel: UILabel! {
        didSet {
            nameErrorLabel.isHidden = true
        }
    }
    @IBOutlet weak var emailErrorLabel: UILabel! {
        didSet {
            emailErrorLabel.isHidden = true
        }
    }
    @IBOutlet weak var birthErrorLabel: UILabel! {
        didSet {
            birthErrorLabel.isHidden = true
        }
    }
    @IBOutlet weak var confirmButton: UIButton! {
        didSet {
            confirmButton.isEnabled = false
        }
    }
    
    // Private vars
    private let _disposeBag = DisposeBag()
    private enum SignUpSegue: String {
        case ShowWeatherView
    }
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        // Config RX
        setUpTextChangeHandling()
    }
    
    // MARK: - Private Functions
    private func setUpView() {
        birthTextField.defineAsDatePicker(target: self, valueChangedAction: #selector(datePickerChanged(picker:)))
    }
    
    private func setUpTextChangeHandling() {
        handleErrorTextFieldValidation()
        
        // Valid fields to enable confirm button
        let nameValid = nameTextField
            .rx
            .text
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .map { !($0?.isEmpty ?? true) }
        
        let emailValid = emailTextField
            .rx
            .text
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .map { Utilities.isValidEmail($0) }

        let birthValid = birthTextField
            .rx
            .text
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .map { !($0?.isEmpty ?? true) }
        
        let everythingValid = Observable
            .combineLatest(nameValid, emailValid, birthValid) {
                $0 && $1 && $2
        }

        everythingValid
            .bind(to: confirmButton.rx.isEnabled)
            .disposed(by: _disposeBag)
    }
    
    private func handleErrorTextFieldValidation() {
        // Handling RX Name
        nameTextField.rx.controlEvent([.editingDidEnd]).subscribe { [unowned self] text in
            self.nameErrorLabel.isHidden = !(self.nameTextField.text?.isEmpty ?? true)
            
        }.disposed(by: _disposeBag)
        
        // Handling RX Email
        emailTextField.rx.controlEvent([.editingDidEnd]).subscribe { [unowned self] text in
            self.emailErrorLabel.isHidden = Utilities.isValidEmail(self.emailTextField.text)
            
        }.disposed(by: _disposeBag)
        
        // Handling RX birth
        birthTextField.rx.controlEvent([.editingDidEnd]).subscribe { [unowned self] text in
            self.birthErrorLabel.isHidden = !(self.birthTextField.text?.isEmpty ?? true)

        }.disposed(by: _disposeBag)
    }
    
    // MARK: - IBActions
    @objc func datePickerChanged(picker: UIDatePicker) {
        birthTextField.text = picker.date.formattedStringDate()
        
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        Utilities.saveUserDidSignUp()
        performSegue(withIdentifier: SignUpSegue.ShowWeatherView.rawValue, sender: nil)
    }
}
