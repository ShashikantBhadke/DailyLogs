//
//  AlertTitle&Btn.swift
//  Shride_iOS
//
//  Created by Shashikant's_Macmini on 21/02/20.
//  Copyright © 2020 redbytes. All rights reserved.
//
import Foundation

extension Alert {
    
    /// Enum For Alert Controller Titles
    enum AlertTitle: String {
        case error          = "Error!"
        case warning        = "Warning!"
        case login          = "Login"
        case success        = "Success!"
        case fileSelected   = "File Selected"
        case sorry          = "Sorry!"
    }
    
    /// Enum For Alert Button Titles
    enum AlertButton: String {
        case okay           = "OK"
        case done           = "Done"
        case cancel         = "Cancel"
        case logout         = "Logout"
    }
        
} //Alert
