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
    static var deletedRecord = PublishSubject<RecordModel>()
    
    static var category = PublishSubject<CategoryModel>()
    
    static func initialSetUp() {
        Database.database().isPersistenceEnabled = true
        FirebaseHelper.dataBaseRef = Database.database().reference()
    }
    
}
