//
//  SplashController.swift
//  DailyLogs
//
//  Created by Shashikant Bhadke on 23/06/21.
//

import UIKit

final class SplashController: UIViewController {
    
    @IBOutlet private weak var appNameLabel: UILabel!
    
    override func viewDidLoad() {
        appNameLabel.alpha = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.5) {
            self.appNameLabel.alpha = 1
        }
        
        UIView.animate(withDuration: 2) {
            self.appNameLabel.transform = CGAffineTransform(scaleX: 3, y: 3)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.pushLoginController()
        }
    }
    
    private func pushLoginController() {
        guard let loginController = UIStoryboard.main.instantiateViewController(withIdentifier: String(describing: LoginController.self)) as? LoginController else { return }
        self.navigationController?.setViewControllers([loginController], animated: true)
    }
    
}
