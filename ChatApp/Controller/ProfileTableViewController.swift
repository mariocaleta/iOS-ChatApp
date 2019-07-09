//
//  ProfileTableViewController.swift
//  ChatApp
//
//  Created by Mario Ćaleta on 07/07/2019.
//  Copyright © 2019 FER. All rights reserved.
//

import UIKit
import ProgressHUD

class ProfileTableViewController: UITableViewController {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var statusLabel: UITextField!
    @IBOutlet weak var genderSegment: UISegmentedControl!
    @IBOutlet weak var ageTextField: UITextField!
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        observeData()
    }
    
    func setupView() {
        setupAvatar()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupAvatar() {
        avatar.layer.cornerRadius = 40
        avatar.clipsToBounds = true
        avatar.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        avatar.addGestureRecognizer(tapGesture)
    }
    
    @objc func presentPicker() {
        view.endEditing(true)
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func observeData() {
        Api.User.getUserInforSingleEvent(uid: Api.User.currentUserId) { (user) in
            self.usernameLabel.text = user.username
            self.emailLabel.text = user.email
            self.statusLabel.text = user.status
            self.avatar.loadImage(user.profileImageUrl)
            
            if let age = user.age {
                self.ageTextField.text = "\(age)"
            } else {
                self.ageTextField.placeholder = "Optional"
            }
            
            if let isMale = user.isMale {
                self.genderSegment.selectedSegmentIndex = (isMale == true) ? 0 : 1
            }
        }
    }

    @IBAction func logoutButtonDidTapped(_ sender: Any) {
        Api.User.logOut()
    }
    
    @IBAction func saveButtonDidTapped(_ sender: Any) {
        ProgressHUD.show("Loading...")
        
        var dict = Dictionary<String, Any>()
        if let username = usernameLabel.text, !username.isEmpty {
            dict["username"] = username
        }
        if let email = emailLabel.text, !email.isEmpty {
            dict["email"] = email
        }
        if let status = statusLabel.text, !status.isEmpty {
            dict["status"] = status
        }
        if genderSegment.selectedSegmentIndex == 0 {
            dict["isMale"] = true
        }
        if genderSegment.selectedSegmentIndex == 1 {
            dict["isMale"] = false
        }
        if let age = ageTextField.text, !age.isEmpty {
            dict["age"] = Int(age)
        }
        
        Api.User.saveUserProfile(dict: dict, onSuccess: {
            if let img = self.image {
                StorageService.savePhotoProfile(image: img, uid: Api.User.currentUserId, onSuccess: {
                    ProgressHUD.showSuccess()
                }) { (errorMessage) in
                    ProgressHUD.showError(errorMessage)
                }
            } else {
                ProgressHUD.showSuccess()
            }
            
        }) { (errorMessage) in
            ProgressHUD.showError(errorMessage)
        }
    }
}

extension ProfileTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = imageSelected
            avatar.image = imageSelected
        }
        if let imageOriginl = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = imageOriginl
            avatar.image = imageOriginl
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
