//
//  RecordCell.swift
//  DailyLogs
//
//  Created by Shashikant Bhadke on 24/06/21.
//

import UIKit

final class RecordCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel       : UILabel!
    @IBOutlet weak var detailsLabel     : UILabel!
    @IBOutlet weak var amountLabel      : UILabel!
    @IBOutlet weak var dateLabel	    : UILabel!
    @IBOutlet weak var viewBackground   : UIView!
    
    override func awakeFromNib() {
        viewBackground.setCorner(withRadius: 5)
    }
    
    func setData(_ record: RecordModel) {
        titleLabel.text = record.title
        detailsLabel.text = record.detail
        dateLabel.text = Date(timestamp: record.timeStamp).getString() ?? ""
        
        switch record.amountType {
        case .credited:
            amountLabel.text = "+ \(record.amount)"
            amountLabel.textColor = .green
        case .debited:
            amountLabel.text = "- \(record.amount)"
            amountLabel.textColor = .red
        case .unknown:
            amountLabel.text = "\(record.amount)"
            amountLabel.textColor = .black
        }
    }
    
}
