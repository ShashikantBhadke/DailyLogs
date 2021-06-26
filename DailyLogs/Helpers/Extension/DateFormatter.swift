//
//  DateFormatter.swift
//  DailyLogs
//
//  Created by Shashikant Bhadke on 24/06/21.
//

import Foundation

extension DateFormatter {
    
    static var getFormatter: DateFormatter = {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "E, d MMM yyyy"
        return dateformatter
    }()
    
}
