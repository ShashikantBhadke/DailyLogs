//
//  Firebase.swift
//  DailyLogs
//
//  Created by Shashikant Bhadke on 27/06/21.
//

import Foundation
import RxSwift
import FirebaseAuth
import FirebaseDatabase

final class FirebaseHelper {
    
    static var dataBaseRef: DatabaseReference!
    
    static var newRecord = PublishSubject<RecordModel>()
    static var updatedRecord = PublishSubject<RecordModel>()
    static var deletedRecord = PublishSubject<RecordModel>()
    
    static var category = PublishSubject<CategoryModel>()
    
    static func initialSetUp() {
        Database.database().isPersistenceEnabled = true
        FirebaseHelper.dataBaseRef = Database.database().reference()
    }
    
    static func getRecordReference() -> DatabaseReference {
        return dataBaseRef.child(DatabaseTable.records.rawValue).child(Auth.auth().currentUser?.uid ?? "user")
    }
    
    static func getCategoryReference() -> DatabaseReference {
        return dataBaseRef.child(DatabaseTable.category.rawValue).child(Auth.auth().currentUser?.uid ?? "user")
    }
    
}
