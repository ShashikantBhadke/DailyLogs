//
//  LoginControllerTexts.swift
//  DailyLogsTests
//
//  Created by Shashikant Bhadke on 24/06/21.
//

import XCTest
@testable import DailyLogs

class LoginControllerTexts: XCTestCase {

    var loginController: LoginController?
    
    override func setUpWithError() throws {
        loadLoginController()
    }

    private func loadLoginController() {
        loginController = UIStoryboard.main.instantiateViewController(identifier: String(describing: LoginController.self)) as? LoginController
        loginController?.loadView()
    }
    
    func test_IBOutlets() {
        do {
            _ = try XCTUnwrap(loginController?.mailTextField, "Mail textfield is not connected.")
            _ = try XCTUnwrap(loginController?.passwordTextField, "Password textfield is not connected.")
            _ = try XCTUnwrap(loginController?.loginButton, "Login button is not connected.")
            _ = try XCTUnwrap(loginController?.viewShowPasswordButton, "View for show password button is not connected.")
            _ = try XCTUnwrap(loginController?.showPasswordButton, "show password button is not connected.")
            
        } catch {}
    }
    
    override func tearDownWithError() throws {
        loginController = nil
    }

}
