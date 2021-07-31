//
//  RecordHeaderCell.swift
//  DailyLogs
//
//  Created by Shashikant Bhadke on 30/06/21.
//

import UIKit

final class RecordHeaderCell: UITableViewCell {
    
    @IBOutlet weak var creditedLabel        : UILabel!
    @IBOutlet weak var debitedLabel         : UILabel!
    @IBOutlet weak var balanceLabel         : UILabel!
    @IBOutlet weak var totalBalanceLabel    : UILabel!
    @IBOutlet weak var dateLabel            : UILabel!
    
    override func awakeFromNib() {
    }
    
    override func prepareForReuse() {
        totalBalanceLabel.text = ""
    }
    
    func setData(_ spendingDetails: SpendingDetailsModel) {
        creditedLabel.text = spendingDetails.credited
        debitedLabel.text = spendingDetails.debited
        balanceLabel.text = spendingDetails.balance
        balanceLabel.textColor = spendingDetails.balanceColor
        dateLabel.text = spendingDetails.date
        if !spendingDetails.totalBalance.isEmpty {
            totalBalanceLabel.text = "Total Balance: \(spendingDetails.totalBalance)"
            totalBalanceLabel.textColor = spendingDetails.totalBalanceColor
        }
    }
    
}
