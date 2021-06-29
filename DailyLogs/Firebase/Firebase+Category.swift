//
//  Firebase+Category.swift
//  DailyLogs
//
//  Created by Shashikant Bhadke on 27/06/21.
//

import Foundation
import RxSwift
import FirebaseDatabase

extension FirebaseHelper {
    
    // Records
    static func observeNewCategory() {
        FirebaseHelper.getCategoryReference()
            .observe(.childAdded) { snapshot in
                if let dictionary = snapshot.value as? [String: Any] {
                    if let object = CategoryModel.getObject(dictionary: dictionary) {
                        category.onNext(object)
                    }
                }
            }
    }
    
    static func observeRemoveCategory() {
        FirebaseHelper.getCategoryReference()
            .observe(.childRemoved) { snapshot in
                if var dictionary = snapshot.value as? [String: Any] {
                    dictionary["id"] = snapshot.key
                    if let recordObject = RecordModel.getObject(dictionary: dictionary) {
                        deletedRecord.onNext(recordObject)
                    }
                }
            }
    }
    
    static func deleteCategory(id: String) {
        FirebaseHelper.getCategoryReference()
            .child(id)
            .removeValue()
    }
    
    static func saveOrUpdateCategory(id: String? = nil, _ object: [String:Any]) {
        if let strId = id {
            FirebaseHelper.getCategoryReference()
                .child(strId)
                .setValue(object)
        } else {
            FirebaseHelper.getCategoryReference()
                .childByAutoId()
                .setValue(object)
        }
    }
    
}
