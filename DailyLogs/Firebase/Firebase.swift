//
//  Firebase.swift
//  DailyLogs
//
//  Created by Shashikant Bhadke on 27/06/21.
//

import Foundation
import RxSwift
import FirebaseDatabase

final class FirebaseHelper {
    
    static var dataBaseRef: DatabaseReference!
    static var newRecord = PublishSubject<RecordModel>()
    
    static func initialSetUp() {
        Database.database().isPersistenceEnabled = true
        FirebaseHelper.dataBaseRef = Database.database().reference()
    }
    
    // Records
    static func observeNewAddedRecord() {
        dataBaseRef.child(DatabaseTable.records.rawValue)
            .observe(.childAdded, with: { snapshot in
                if var dictionary = snapshot.value as? [String: Any] {
                    dictionary["id"] = snapshot.key
                    if let recordObject = RecordModel.getObject(dictionary: dictionary) {
                        newRecord.onNext(recordObject)
                    }
                }
            })
    }
    
    static func deleteRecord(id: String) {
        dataBaseRef.child(DatabaseTable.records.rawValue)
            .child(id)
            .removeValue()
    }
    
    static func saveRecord(_ object: [String:Any]) {
        dataBaseRef.child(DatabaseTable.records.rawValue)
            .childByAutoId()
            .setValue(object)
    }
    
}
