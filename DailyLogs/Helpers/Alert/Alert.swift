//
//  Alert.swift
//  Shride_iOS
//
//  Created by Shashikant's_Macmini on 21/02/20.
//  Copyright © 2020 redbytes. All rights reserved.
//

import UIKit

final class Alert {
    
    class func show(_ title: AlertTitle, _ message: AlertMessage, _ btnTitles: [AlertButton] = [AlertButton.okay], controller: UIViewController? = nil, _ handler: ((String) -> Void)? = nil) {
        
        let alertController = UIAlertController.init(title: title.rawValue, message: message.rawValue, preferredStyle: .alert)
        btnTitles.forEach { (btnTitle) in
            let action = UIAlertAction.init(title: btnTitle.rawValue, style: .default, handler: { (_ ) in
                handler?(btnTitle.rawValue)
            })
            alertController.addAction(action)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            present(alertController, controller: controller ?? AppDelegate().topViewController())
        }
    }
    
    class func show(_ title: AlertTitle, _ message: String, _ btnTitles: [AlertButton] = [AlertButton.okay], controller: UIViewController? = nil, _ handler: ((String) -> Void)? = nil) {
        
        let alertController = UIAlertController.init(title: title.rawValue, message: message, preferredStyle: .alert)
        btnTitles.forEach { (btnTitle) in
            let action = UIAlertAction.init(title: btnTitle.rawValue, style: .default, handler: { (_ ) in
                handler?(btnTitle.rawValue)
            })
            alertController.addAction(action)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            present(alertController, controller: controller ?? AppDelegate().topViewController())
        }
    }
    
    class func show(_ title: String, _ message: String, _ btnTitles: [AlertButton] = [AlertButton.okay], controller: UIViewController? = nil, _ handler: ((String) -> Void)? = nil) {
        
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        btnTitles.forEach { (btnTitle) in
            let action = UIAlertAction.init(title: btnTitle.rawValue, style: .default, handler: { (_ ) in
                handler?(btnTitle.rawValue)
            })
            alertController.addAction(action)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            present(alertController, controller: controller ?? AppDelegate().topViewController())
        }
    }
    
    class func showOnRoot(_ title: AlertTitle, _ message: AlertMessage, _ btnTitles: [AlertButton] = [AlertButton.okay], controller: UIViewController? = nil, _ handler: ((String) -> Void)? = nil) {
        
        let alertController = UIAlertController.init(title: title.rawValue, message: message.rawValue, preferredStyle: .alert)
        btnTitles.forEach { (btnTitle) in
            let action = UIAlertAction.init(title: btnTitle.rawValue, style: .default, handler: { (_ ) in
                handler?(btnTitle.rawValue)
            })
            alertController.addAction(action)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            present(alertController, controller: controller ?? AppDelegate().topViewController())
        }
    }
    
    class func showOnRoot(_ title: AlertTitle, _ message: String, _ btnTitles: [AlertButton] = [AlertButton.okay], controller: UIViewController? = nil, _ handler: ((String) -> Void)? = nil) {
        
        let alertController = UIAlertController.init(title: title.rawValue, message: message, preferredStyle: .alert)
        btnTitles.forEach { (btnTitle) in
            let action = UIAlertAction.init(title: btnTitle.rawValue, style: .default, handler: { (_ ) in
                handler?(btnTitle.rawValue)
            })
            alertController.addAction(action)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            present(alertController, controller: controller ?? AppDelegate().topViewController())
        }
    }
    
    class func showActionSheet(_ title: String, _ message: String, _ btnTitles: [AlertButton] = [AlertButton.okay], controller: UIViewController? = nil, _ handler: ((String) -> Void)? = nil) {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .actionSheet)
        btnTitles.forEach { (btnTitle) in
            let action = UIAlertAction.init(title: btnTitle.rawValue, style: .default, handler: { (_ ) in
                handler?(btnTitle.rawValue)
            })
            alertController.addAction(action)
        }
        
        let cancelAlert = UIAlertAction.init(title: AlertButton.cancel.rawValue, style: .cancel, handler: { (_ ) in
            handler?(AlertButton.cancel.rawValue)
        })
                
        cancelAlert.setValue(UIColor.systemRed, forKey: "titleTextColor")
                
        alertController.addAction(cancelAlert)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            present(alertController, controller: controller ?? AppDelegate().topViewController())
        }
    }
     
    class func showActionSheet(_ title: String, _ message: String, _ btnTitles: [String], controller: UIViewController? = nil, _ handler: ((String) -> Void)? = nil) {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .actionSheet)
        btnTitles.forEach { (btnTitle) in
            let action = UIAlertAction.init(title: btnTitle, style: .default, handler: { (_ ) in
                handler?(btnTitle)
            })
            alertController.addAction(action)
        }
        
        let cancelAlert = UIAlertAction.init(title: AlertButton.cancel.rawValue, style: .cancel, handler: { (_ ) in
            handler?(AlertButton.cancel.rawValue)
        })
                
        cancelAlert.setValue(UIColor.systemRed, forKey: "titleTextColor")
                
        alertController.addAction(cancelAlert)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            present(alertController, controller: controller ?? AppDelegate().topViewController())
        }
    }
    
    class private func present(_ alert: UIAlertController, controller: UIViewController) {
        guard !(controller.isKind(of: UIAlertController.self)) else { return }
        controller.present(alert, animated: true, completion: nil)
    }
    
} //class
