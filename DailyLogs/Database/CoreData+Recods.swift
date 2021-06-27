//
//  CoreData.swift
//  DailyLogs
//
//  Created by Shashikant Bhadke on 25/06/21.
//

import RxSwift
import CoreData
import Foundation

extension CoreData {
    
    func saveRecord(recordObject: RecordModel) {
        loading.onNext(true)
        defer {
            loading.onNext(false)
        }
        guard let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            error.onNext(CoreDataError.contexNotFound.rawValue)
            return
        }
        guard
            let entity = NSEntityDescription.entity(forEntityName: "Record", in: managedContext),
            let record = NSManagedObject(entity: entity, insertInto: managedContext) as? Record else {
            error.onNext(CoreDataError.newEntity.rawValue)
            return
        }
        
        record.title = recordObject.title
        record.detail = recordObject.detail
        record.amount = recordObject.amount
        record.amountType = Int16(recordObject.amountType.rawValue)
        record.createdOn = recordObject.date
        record.id = Int64(recordCount())
        //record.person = recordObject.person
        
        do {
            try managedContext.save()
            records.onNext([recordObject])
        } catch let customError {
            error.onNext(customError.localizedDescription)
        }
    }
    
    private func recordCount() -> Int {
        guard let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            return 0
        }
        let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()
        do {
            return try managedContext.fetch(fetchRequest).count
        } catch let customError {
            debugPrint(customError.localizedDescription)
        }
        return 0
    }
    
    func fetchRecords() {
        loading.onNext(false)
        defer {
            loading.onNext(false)
        }
        guard let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            error.onNext(CoreDataError.contexNotFound.rawValue)
            return
        }
        let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()
        
        do {
            
            let recordObject = try managedContext.fetch(fetchRequest)
            let arrayRecord = recordObject.map {
                RecordModel(amountType: AmountType(rawValue: Int($0.amountType)) ?? .unknown,
                            amount: $0.amount ,
                            title: $0.title ?? "",
                            date: $0.createdOn,
                            detail: $0.detail,
                            person: $0.person?.name ?? "")
            }
            records.onNext(arrayRecord)
        } catch let customError {
            error.onNext(customError.localizedDescription)
        }
    }
    
    func fetchRecords(startDate: NSDate, endDate: NSDate) {
        loading.onNext(false)
        defer {
            loading.onNext(false)
        }
        guard let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            error.onNext(CoreDataError.contexNotFound.rawValue)
            return
        }
        let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "createdOn => %@ AND createdOn =< %@", startDate, endDate)
        
        do {
             let recordObject = try managedContext.fetch(fetchRequest)
            let arrayRecord = recordObject.map {
                RecordModel(id: $0.id,
                            amountType: AmountType(rawValue: Int($0.amountType)) ?? .unknown,
                            amount: $0.amount ,
                            title: $0.title ?? "",
                            date: $0.createdOn,
                            detail: $0.detail,
                            person: $0.person?.name ?? "")
            }
            records.onNext(arrayRecord)
        } catch let customError {
            error.onNext(customError.localizedDescription)
        }
    }
    
    func deleteRecord(_ record: RecordModel) {
        loading.onNext(false)
        defer {
            loading.onNext(false)
        }
        guard let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            error.onNext(CoreDataError.contexNotFound.rawValue)
            return
        }
        let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d AND createdOn == %@", record.id, record.date! as NSDate)
        
        do {
             let recordObject = try managedContext.fetch(fetchRequest)
            recordObject.forEach { recordObj in
                managedContext.delete(recordObj)
            }
            try managedContext.save()
            records.onNext([])
        } catch let customError {
            error.onNext(customError.localizedDescription)
        }
    }
    
}
