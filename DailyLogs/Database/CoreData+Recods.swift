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
        //record.id =
        //record.person = recordObject.person
        
        do {
            try managedContext.save()
            records.onNext([recordObject])
        } catch let customError {
            error.onNext(customError.localizedDescription)
        }
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
    
    func getTotalSum() {
        guard let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            error.onNext(CoreDataError.contexNotFound.rawValue)
            return
        }
//        let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()
//        fetchRequest.resultType = .dictionaryResultType
//        let sumExpression = NSExpression(format: "sum:(amount)")
//        let sumED = NSExpressionDescription()
//        sumED.expression = sumExpression
//        sumED.name = "sumOfAmount"
//        sumED.expressionResultType = .doubleAttributeType
//        fetchRequest.propertiesToFetch = ["amount", sumED]
//        //fetchRequest.propertiesToGroupBy = ["amound"]
//
//        do {
//            let results = try managedContext.execute(fetchRequest)
//            debugPrint(results)
//        } catch {
//            debugPrint(error.localizedDescription)
//        }
        
        let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.returnsObjectsAsFaults = false

        let expression = NSExpressionDescription()
        expression.expression =  NSExpression(forFunction: "sum:", arguments:[NSExpression(forKeyPath: "amount")])
        expression.name = "sumOfEstimatedValue"
        expression.expressionResultType = .decimalAttributeType
        fetchRequest.propertiesToFetch = [expression]

        do {
            let opportunityAggregates = try managedContext.execute(fetchRequest)
            print(opportunityAggregates)
        } catch {
            print("Failed to fetch aggregates")
        }
    }
    
}
