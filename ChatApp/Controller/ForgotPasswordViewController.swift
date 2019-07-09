//
//  ForgotPasswordViewController.swift
//  ChatApp
//
//  Created by Mario Ćaleta on 30/06/2019.
//  Copyright © 2019 FER. All rights reserved.
//

import UIKit
import ProgressHUD

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emalTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        
        setupEmailTextField()
        setupResetButton()
    }
    @IBAction func dismissAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resetPasswordDidTapped(_ sender: Any) {
        guard let email = emalTextField.text, email != "" else {
            ProgressHUD.showError(ERROR_EMPTY_EMAIL_RESET)
            return
        }
        
        Api.User.resetPassword(email: email, onSuccess: {
            self.view.endEditing(true)
            ProgressHUD.showSuccess(SUCCES_EMAIL_RESET)
            self.navigationController?.popViewController(animated: true)
        }) {(errorMessage) in
            ProgressHUD.showError(errorMessage)
        }
    }
}
