//
//  UserData.swift
//  DailyLogs
//
//  Created by Shashikant Bhadke on 26/06/21.
//

import Foundation

final class UserData {
    
    enum UserDataKey : String {
        case mail               = "Mail"
        case password           = "Password"
        case isRemember         = "isRemember"
    }
    
    private init() {}
    private static let userdefault = UserDefaults.standard
    
    class func saveData(_ type: UserDataKey, _ value: Any) {
        userdefault.set(value, forKey: type.rawValue)
    }
    
    class func returnValue(_ type: UserDataKey)->Any? {
        return userdefault.value(forKey: type.rawValue)
    }
    
    class func synchronize() {
        userdefault.synchronize()
    }
    
    class func clearData() {
        let domain = Bundle.main.bundleIdentifier!
        userdefault.removePersistentDomain(forName: domain)
        userdefault.synchronize()
    }
    
    class func clearDataForKey(userDataKeys: [UserDataKey]) {
        for userDataKey in userDataKeys {
            userdefault.removeObject(forKey: userDataKey.rawValue)
        }
    }
    
}
