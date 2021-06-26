//
//  CoreData.swift
//  DailyLogs
//
//  Created by Shashikant Bhadke on 25/06/21.
//

import RxSwift
import CoreData
import Foundation

final class CoreData {
    
    public let login    : PublishSubject<[User]> = PublishSubject()
    public let register : PublishSubject<[User]> = PublishSubject()
    public let users    : PublishSubject<[User]> = PublishSubject()
    public let records  : PublishSubject<[RecordModel]> = PublishSubject()
    public let loading  : PublishSubject<Bool> = PublishSubject()
    public let error    : PublishSubject<String> = PublishSubject()
    
    enum CoreDataError: String {
        case contexNotFound = "CoreData context not found."
        case dataNotFound = "Data not found."
        case newEntity = "Unable to create entity type."
        case failToParse = "Fail to typecast object."
        case mailOccupied = "Mail is already occupied try with other mail."
    }
    
    let context = {
        return (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    }()
}
