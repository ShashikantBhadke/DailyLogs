//
//  LoginController.swift
//  DailyLogs
//
//  Created by Shashikant Bhadke on 23/06/21.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase

final class LoginController: UIViewController {

    @IBOutlet weak var mailTextField            : UITextField!
    @IBOutlet weak var passwordTextField        : UITextField!
    @IBOutlet weak var loginButton              : UIButton!
    @IBOutlet weak var registerButton           : UIButton!
    @IBOutlet weak var rememberPasswordButton   : UIButton!
    @IBOutlet weak var showPasswordButton       : UIButton!
    @IBOutlet weak var viewShowPasswordButton   : UIView!
    
    let disposeBag = DisposeBag()
    let loginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setUpView() {
        loginButton.setCorner(withRadius: 10)
        registerButton.setCorner(withRadius: 10)
        passwordTextField.rightView = viewShowPasswordButton
        passwordTextField.rightViewMode = .always
        
        if UserData.returnValue(.isRemember) as? Bool ?? false {
            rememberPasswordButton.isSelected = true
            mailTextField.text = UserData.returnValue(.mail) as? String ?? ""
            passwordTextField.text = UserData.returnValue(.password) as? String ?? ""
        }
        
        if Auth.auth().currentUser != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let self = self else { return }
                self.pushRecordsController()
            }
            return
        }
        bindView()
    }
    
    func bindView() {
        
        self.loginButton.rx.tap
            .withLatestFrom(
                Observable.combineLatest(mailTextField.rx.text.orEmpty, passwordTextField.rx.text.orEmpty)
            )
            .subscribe(onNext: { mail, password in
                debugPrint(mail, password)
                Auth.auth().signIn(withEmail: mail, password: password) { [weak self] _, error in
                  guard let self = self else { return }
                    if let errorMessage = error?.localizedDescription {
                        Alert.show("", errorMessage)
                    } else {
                        self.saveData(mail, password)
                        self.pushRecordsController()
                    }
                }
            })
            .disposed(by: disposeBag)
        
        self.registerButton.rx.tap
            .withLatestFrom(
                Observable.combineLatest(mailTextField.rx.text.orEmpty, passwordTextField.rx.text.orEmpty)
            )
            .subscribe(onNext: { mail, password in
                Auth.auth().createUser(withEmail: mail, password: password) { [weak self] _, error in
                  guard let self = self else { return }
                    if let errorMessage = error?.localizedDescription {
                        Alert.show("", errorMessage)
                    } else {
                        self.saveData(mail, password)
                        Alert.show("", "Acount created successfully please tap on login.")
                    }
                }
            })
            .disposed(by: disposeBag)
        
        self.rememberPasswordButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.rememberPasswordButton.isSelected.toggle()
            UserData.saveData(.isRemember, self.rememberPasswordButton.isSelected)
        })
        .disposed(by: disposeBag)
        loginViewModel.showPasswordBehaviorRelay.asObservable().bind(to: showPasswordButton.rx.isSelected).disposed(by: disposeBag)
        
        showPasswordButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
            if let self = self {
                self.loginViewModel.showPasswordBehaviorRelay.accept(!self.loginViewModel.showPasswordBehaviorRelay.value)
                self.passwordTextField.isSecureTextEntry = self.loginViewModel.showPasswordBehaviorRelay.value
            }
        }).disposed(by: disposeBag)
    }
    
    func bindView_() {
        mailTextField.rx.text.map {$0 ?? ""}.bind(to: loginViewModel.mailTextPublishSubject).disposed(by: disposeBag)
        passwordTextField.rx.text.map {$0 ?? ""}.bind(to: loginViewModel.passwordTextPublishSubject).disposed(by: disposeBag)
        
        loginViewModel.showPasswordBehaviorRelay.asObservable().bind(to: showPasswordButton.rx.isSelected).disposed(by: disposeBag)
        showPasswordButton.rx.tap.subscribe(onNext: { [weak self] _ in
            if let self = self {
                self.loginViewModel.showPasswordBehaviorRelay.accept(!self.loginViewModel.showPasswordBehaviorRelay.value)
                self.passwordTextField.isSecureTextEntry = self.loginViewModel.showPasswordBehaviorRelay.value
            }
        }).disposed(by: disposeBag)
        
        loginViewModel.isValid().bind(to: loginButton.rx.isEnabled).disposed(by: disposeBag)
        loginViewModel.isValid().map {$0 ? 1 : 0.3}.bind(to: loginButton.rx.alpha).disposed(by: disposeBag)
    }
    
    func saveData(_ mail: String, _ password: String) {
        if rememberPasswordButton.isSelected {
            UserData.saveData(.mail, mail)
            UserData.saveData(.password, password)
        }
    }
    
    func pushRecordsController() {
        guard let recordsController = UIStoryboard.records.instantiateViewController(withIdentifier: String(describing: RecordsController.self)) as? RecordsController else { return }
        self.navigationController?.viewControllers = [recordsController]
        
    }
    
    override func didReceiveMemoryWarning() {
        debugPrint("Receive Memory Warning For", #file)
    }
    
    deinit {
        debugPrint("File Deinit", #file)
    }
    
}
