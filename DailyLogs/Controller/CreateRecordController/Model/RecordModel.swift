//
//  RecordModel.swift
//  DailyLogs
//
//  Created by Shashikant Bhadke on 24/06/21.
//

import Foundation

struct RecordModel: Codable, Equatable {
    var id: String = ""
    var amountType: AmountType
    var amount = ""
    var title: String = ""
    var timeStamp: Int64 = Date().timestamp
    var detail: String?
    var category: String = ""
    
    static func getDummy() -> RecordModel {
        return RecordModel(amountType: .unknown)
    }
    
    func getDictionary()-> [String:Any] {
        do {
            let data = try JSONEncoder().encode(self)
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
        } catch {
            debugPrint(error.localizedDescription)
        }
        return [:]
    }
    
    static func getObject(data: Data) -> RecordModel? {
        do {
            return try JSONDecoder().decode(RecordModel.self, from: data)
        } catch {
            debugPrint(error.localizedDescription)
        }
        return nil
    }
    
    static func getObject(dictionary: [String:Any]) -> RecordModel? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            return getObject(data: jsonData)
        } catch {
            debugPrint(error.localizedDescription)
        }
        return nil
    }
    
}
