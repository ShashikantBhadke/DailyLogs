//
//  Enums.swift
//  DailyLogs
//
//  Created by Shashikant Bhadke on 24/06/21.
//

import Foundation

enum AmountType: Int, Codable {
    case unknown = -1
    case credited = 0
    case debited = 1
}

enum PaymentMethod: String {
    case card = "Card"
    case cash = "Cash"
    case gpay = "GPay"
    case phonepe = "PhonePe"
    case sbi = "SBI"
    case icici = "ICICI"
}
