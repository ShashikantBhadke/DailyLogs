//
//  CreateRecordViewModel.swift
//  DailyLogs
//
//  Created by Shashikant Bhadke on 24/06/21.
//

import RxSwift
import RxRelay
import Foundation

final class CreateRecordViewModel {
    
    let record = BehaviorRelay<RecordModel>(value: RecordModel.getDummy())
    
    func isValid()-> Observable<Bool> {
        return record.asObservable().map { recordObject -> Bool in
            if recordObject.amount < 0 {
                return false
            }
            
            if recordObject.title.isEmpty {
                return false
            }
            if recordObject.category.isEmpty {
                return false
            }
            return true
        }
    }
    
}
