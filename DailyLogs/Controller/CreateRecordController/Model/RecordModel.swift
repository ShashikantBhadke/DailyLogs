//
//  RecordModel.swift
//  DailyLogs
//
//  Created by Shashikant Bhadke on 24/06/21.
//

import Foundation

struct RecordModel {
    var id: Int64 = 0
    var amountType: AmountType
    var amount: Double = 0
    var title: String = ""
    var date: Date?
    var detail: String?
    var person: String?
    
    static func getDummy() -> RecordModel {
        return RecordModel(amountType: .credited, amount: 0.0, title: "", date: Date(), detail: "", person: "")
    }
}
