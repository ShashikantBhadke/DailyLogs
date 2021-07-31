//
//  Firebase+Record.swift
//  DailyLogs
//
//  Created by Shashikant Bhadke on 27/06/21.
//

import RxSwift
import Foundation
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
    
    static func observeRecordUpdate() {
        FirebaseHelper.getRecordReference()
            .observe(.childChanged, with: { snapshot in
                if var dictionary = snapshot.value as? [String: Any] {
                    dictionary["id"] = snapshot.key
                    if let recordObject = RecordModel.getObject(dictionary: dictionary) {
                        updatedRecord.onNext(recordObject)
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
    
    static func deleteRecord(recordId: String) {
        FirebaseHelper.getRecordReference()
            .child(recordId)
            .removeValue()
    }
    
    static func saveRecord(_ object: [String:Any]) {
        if let recordId = object["id"] as? String,
           !recordId.isEmpty {
            FirebaseHelper.getRecordReference()
                .child(recordId)
                .setValue(object)
        } else {
            FirebaseHelper.getRecordReference()
                .childByAutoId()
                .setValue(object)
        }
    }
    
}
