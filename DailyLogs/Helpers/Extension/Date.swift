//
//  Date.swift
//  DailyLogs
//
//  Created by Shashikant Bhadke on 24/06/21.
//

import Foundation

extension Date {
    
    init(timestamp:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(timestamp))
    }
    
    var timestamp:Int64 {
        return Int64((self.timeIntervalSince1970).rounded())
    }
    
    func getString() -> String? {
        let dateformatter = DateFormatter.getFormatter
        return dateformatter.string(from: self)
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
}
