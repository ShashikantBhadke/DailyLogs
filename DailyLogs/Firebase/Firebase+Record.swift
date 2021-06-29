//
//  Firebase+Record.swift
//  DailyLogs
//
//  Created by Shashikant Bhadke on 27/06/21.
//

import Foundation
import RxSwift
import FirebaseDatabase

extension FirebaseHelper {
    
    // Records
    static func observeNewAddedRecord() {
        FirebaseHelper.getRecordReference()
            .observe(.childAdded, with: { snapshot in
                if var dictionary = snapshot.value as? [String: Any] {
                    dictionary["id"] = snapshot.key
                    if let recordObject = RecordModel.getObject(dictionary: dictionary) {
                        newRecord.onNext(recordObject)
                    }
                }
            })
    }
    
    static func observeRemoveRecord() {
        FirebaseHelper.getRecordReference()
            .observe(.childRemoved, with: { snapshot in
                if var dictionary = snapshot.value as? [String: Any] {
                    dictionary["id"] = snapshot.key
                    if let recordObject = RecordModel.getObject(dictionary: dictionary) {
                        deletedRecord.onNext(recordObject)
                    }
                }
            })
    }
    
    static func deleteRecord(id: String) {
        FirebaseHelper.getRecordReference()
            .child(id)
            .removeValue()
    }
    
    static func saveRecord(_ object: [String:Any]) {
        FirebaseHelper.getRecordReference()
            .childByAutoId()
            .setValue(object)
    }
    
}
