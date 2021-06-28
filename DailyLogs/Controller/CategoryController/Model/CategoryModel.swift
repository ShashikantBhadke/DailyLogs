//
//  CategoryModel.swift
//  DailyLogs
//
//  Created by Shashikant Bhadke on 27/06/21.
//

import Foundation

struct CategoryModel: Codable, Equatable {
    
    var id: String
    var name: String
    var icon: String
    
    func getDictionary()-> [String:Any] {
        do {
            let data = try JSONEncoder().encode(self)
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
        } catch {
            debugPrint(error.localizedDescription)
        }
        return [:]
    }
    
    static func getObject(data: Data) -> CategoryModel? {
        do {
            return try JSONDecoder().decode(CategoryModel.self, from: data)
        } catch {
            debugPrint(error.localizedDescription)
        }
        return nil
    }
    
    static func getObject(dictionary: [String:Any]) -> CategoryModel? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            return getObject(data: jsonData)
        } catch {
            debugPrint(error.localizedDescription)
        }
        return nil
    }
    
    static func == (lhs: CategoryModel, rhs: CategoryModel) -> Bool {
        return lhs.name == rhs.name
    }
}
