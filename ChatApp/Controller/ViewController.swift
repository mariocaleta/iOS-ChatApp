//
//  ViewController.swift
//  ChatApp
//
//  Created by Mario Ćaleta on 29/06/2019.
//  Copyright © 2019 FER. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var signInFacebookButton: UIButton!
    @IBOutlet weak var signInGoogleButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var termsOfServiceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        setUpHeaderTitle()
        setUpOrLabel()
        setUpTermsOfServiceLabel()
        setUpFacebookButton()
        setUpGoogleButton()
        setUpCreateAccountButton()
    }
}

