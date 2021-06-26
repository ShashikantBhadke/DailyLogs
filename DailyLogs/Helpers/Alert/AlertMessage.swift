//
//  AlertMessage.swift
//  Shride_iOS
//
//  Created by Shashikant's_Macmini on 21/02/20.
//  Copyright © 2020 redbytes. All rights reserved.
//

import UIKit

extension Alert {
    
    /// Enum For Alert Message
    enum AlertMessage: String {
        case oops               = "Oops something went. Please try again!"
        case invalidEmail       = "Please enter valid email."
        case email              = "Please enter email."
        case passwordLength     = "Please enter minimum 6 characters password."
    }
    
} //Alert
