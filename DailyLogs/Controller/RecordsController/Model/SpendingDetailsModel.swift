//
//  SpendingDetailsModel.swift
//  DailyLogs
//
//  Created by Shashikant Bhadke on 30/06/21.
//

import UIKit
import RxDataSources

struct SpendingDetailsModel {
    var date = ""
    var balance = ""
    var credited = ""
    var debited = ""
    var balanceColor = UIColor.black
    var totalBalance = ""
    var totalBalanceColor = UIColor.systemGray2
}

struct TableViewSection {
  var header: String
  var items: [Item]
}
extension TableViewSection: SectionModelType {
  typealias Item = Any

   init(original: TableViewSection, items: [Item]) {
    self = original
    self.items = items
  }
}
