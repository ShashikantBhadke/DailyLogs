//
//  LoginViewModel.swift
//  DailyLogs
//
//  Created by Shashikant Bhadke on 24/06/21.
//

import RxSwift
import RxRelay
import Foundation

final class LoginViewModel {
    
    let showPasswordBehaviorRelay = BehaviorRelay<Bool>(value: true)
    let mailTextPublishSubject = PublishSubject<String>()
    let passwordTextPublishSubject = PublishSubject<String>()
    
    func isValid()-> Observable<Bool> {
        return Observable.combineLatest(mailTextPublishSubject.asObservable().startWith(""), passwordTextPublishSubject.asObservable().startWith("")).map { (mail, password) in
            if !mail.isValidEmail {
                return false
            }
            if password.count < 3 {
                return false
            }
            return true
        }.startWith(false)
    }
    
}
