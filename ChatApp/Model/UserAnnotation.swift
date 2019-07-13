//
//  UserAnnotation.swift
//  ChatApp
//
//  Created by Mario Ćaleta on 09/07/2019.
//  Copyright © 2019 FER. All rights reserved.
//

import Foundation
import MapKit

class UserAnnotation: MKPointAnnotation {
    var uid: String?
    var age: Int?
    var profileImage: UIImage?
    var isMale: Bool?
}
