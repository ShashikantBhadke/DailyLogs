//
//  String.swift
//  DailyLogs
//
//  Created by Shashikant Bhadke on 24/06/21.
//

import Foundation

extension String {
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    var isNumeric: Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
    }
    
    var isDouble: Bool {
        if Double(self) != nil {
            return true
        }
        return false
    }
    
    func getDate() -> Date? {
        let dateformatter = DateFormatter.getFormatter
        return dateformatter.date(from: self)
    }
    
}
