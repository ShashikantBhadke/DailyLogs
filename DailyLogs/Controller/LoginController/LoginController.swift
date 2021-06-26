//
//  LoginController.swift
//  DailyLogs
//
//  Created by Shashikant Bhadke on 23/06/21.
//

import UIKit
import RxSwift
import RxCocoa
import CoreData

final class LoginController: UIViewController {

    @IBOutlet weak var mailTextField            : UITextField!
    @IBOutlet weak var passwordTextField        : UITextField!
    @IBOutlet weak var loginButton              : UIButton!
    @IBOutlet weak var registerButton           : UIButton!
    @IBOutlet weak var rememberPasswordButton   : UIButton!
    @IBOutlet weak var showPasswordButton       : UIButton!
    @IBOutlet weak var viewShowPasswordButton   : UIView!
    
    let coreData = CoreData()
    let disposeBag = DisposeBag()
    let loginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        bindView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setUpView() {
        bindCoreDataModel()
        
        loginButton.setCorner(withRadius: 10)
        registerButton.setCorner(withRadius: 10)
        passwordTextField.rightView = viewShowPasswordButton
        passwordTextField.rightViewMode = .always
        
        if UserData.returnValue(.isRemember) as? Bool ?? false {
            rememberPasswordButton.isSelected = true
            mailTextField.text = UserData.returnValue(.mail) as? String ?? ""
            passwordTextField.text = UserData.returnValue(.password) as? String ?? ""
        }
    }
    
    func bindView() {
        
        self.loginButton.rx.tap
            .withLatestFrom(
                Observable.combineLatest(mailTextField.rx.text.orEmpty, passwordTextField.rx.text.orEmpty)
            )
            .subscribe(onNext: { [weak self] mail, password in
                self?.coreData.login(mail: mail, password: password)
            })
            .disposed(by: disposeBag)
        
        self.registerButton.rx.tap
            .withLatestFrom(
                Observable.combineLatest(mailTextField.rx.text.orEmpty, passwordTextField.rx.text.orEmpty)
            )
            .subscribe(onNext: { [weak self] mail, password in
                self?.coreData.createNewUser(mail: mail, password: password)
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
    
    func bindCoreDataModel() {
        coreData.login.subscribe(onNext: { [weak self] users in
            guard let self = self, let user = users.first else { return }
            if self.rememberPasswordButton.isSelected {
                UserData.saveData(.mail, user.mail ?? "")
                UserData.saveData(.password, user.password ?? "")
            }
            self.pushRecordsController(user)
        })
        .disposed(by: disposeBag)
        coreData.register.subscribe(onNext: { users in
            _ = users.map {
                debugPrint($0.mail ?? "")
            }
        })
        .disposed(by: disposeBag)
        coreData.error.subscribe(onNext: { errorMessage in
            debugPrint(errorMessage)
        })
        .disposed(by: disposeBag)
        coreData.loading.subscribe(onNext: { isLoading in
            debugPrint(isLoading)
        })
        .disposed(by: disposeBag)
    }
    
    func stopListner() {
        coreData.users.dispose()
        coreData.error.dispose()
        coreData.loading.dispose()
    }
    
    func pushRecordsController(_ userObject: NSManagedObject) {
        guard let recordsController = UIStoryboard.records.instantiateViewController(withIdentifier: String(describing: RecordsController.self)) as? RecordsController else { return }
        recordsController.userObject.onNext(userObject)
        self.navigationController?.viewControllers = [recordsController]
        
    }
    
    override func didReceiveMemoryWarning() {
        debugPrint("Receive Memory Warning For", #file)
    }
    
    deinit {
        debugPrint("File Deinit", #file)
    }
    
}
