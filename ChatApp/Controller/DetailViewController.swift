//
//  DetailViewController.swift
//  ChatApp
//
//  Created by Mario Ćaleta on 09/07/2019.
//  Copyright © 2019 FER. All rights reserved.
//

import UIKit
import CoreLocation

class DetailViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var genderImage: UIImageView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var user: User!
    var isMatch = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendButton.layer.cornerRadius = 5
        sendButton.clipsToBounds = true
        
        let backImg = UIImage(named: "close")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        backButton.setImage(backImg, for: UIControl.State.normal)
        backButton.tintColor = .white
        
        backButton.layer.cornerRadius = 35/2
        backButton.clipsToBounds = true
        if isMatch {
            avatar.loadImage(user.profileImageUrl)
        } else {
            avatar.image = user.profileImage
        }
        avatar.clipsToBounds = true
        let frameGradient = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 350)
        avatar.addBlackGradientLayer(frame: frameGradient, colors: [.clear, .black])
        usernameLabel.text = user.username
        if user.age != nil {
            ageLabel.text = " \(user.age!)"
        } else {
            ageLabel.text = ""
        }
        
        if let isMale = user.isMale {
            let genderImgName = (isMale == true) ? "icon-male" : "icon-female"
            genderImage.image = UIImage(named: genderImgName)?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            
        } else {
            genderImage.image = UIImage(named: "icon-gender")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        }
        
        genderImage.tintColor = .white
        
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func backButtonDidTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func sendButtonDidTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
        let chatVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_CHAT) as! ChatViewController
        chatVC.imagePartner = avatar.image
        chatVC.partnerUsername = usernameLabel.text
        chatVC.partnerId = user.uid
        chatVC.partnerUser = user
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    

}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            cell.imageView?.image = UIImage(named: "phone")
            cell.textLabel?.text = "123456789"
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            cell.imageView?.image = UIImage(named: "map-1")
            if !user.latitude.isEmpty, !user.longitude.isEmpty {
                let location = CLLocation(latitude: CLLocationDegrees(Double(user.latitude)!), longitude: CLLocationDegrees(Double(user.longitude)!))
                let geocoder = CLGeocoder()
                geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                    if error == nil, let placemarksArray = placemarks, placemarksArray.count > 0 {
                        if let placemark = placemarksArray.last {
                            var text = ""
                            if let thoroughFare = placemark.thoroughfare {
                                text = "\(thoroughFare)"
                                cell.textLabel?.text = text
                            }
                            if let postalCode = placemark.postalCode {
                                text = text + " " + postalCode
                                cell.textLabel?.text = text
                            }
                            if let locality = placemark.locality {
                                text = text + " "  + locality
                                cell.textLabel?.text = text
                            }
                            if let country = placemark.country {
                                text = text + " "  + country
                                cell.textLabel?.text = text
                            }
                        }
                    }
                }
            }
            cell.selectionStyle = .none
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            cell.textLabel?.text = user.status
            cell.selectionStyle = .none
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MapCell", for: indexPath) as! MapTableViewCell
            cell.controller = self
            if !user.latitude.isEmpty, !user.longitude.isEmpty {
                let location = CLLocation(latitude: CLLocationDegrees(Double(user.latitude)!), longitude: CLLocationDegrees(Double(user.longitude)!))
                cell.configure(location: location)
            }
            cell.selectionStyle = .none
            
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            return 300
        }
        
        return 44
    }
    
    
}
