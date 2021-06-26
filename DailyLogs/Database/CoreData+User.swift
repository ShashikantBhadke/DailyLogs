//
//  CoreData+User.swift
//  DailyLogs
//
//  Created by Shashikant Bhadke on 25/06/21.
//

import RxSwift
import CoreData
import Foundation

extension CoreData {
    
    func createNewUser(mail: String, password: String) {
        loading.onNext(true)
        defer {
            loading.onNext(false)
        }
        guard let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            error.onNext(CoreDataError.contexNotFound.rawValue)
            return
        }
        
        guard checkMailAvailable(mail: mail) else {
            error.onNext(CoreDataError.mailOccupied.rawValue)
            return
        }
        
        guard
            let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext),
            let userObject = NSManagedObject(entity: entity, insertInto: managedContext) as? User else {
            error.onNext(CoreDataError.newEntity.rawValue)
            return
        }
        let id = Int64(self.userCount())
        userObject.userId = id
        userObject.mail = mail
        userObject.password = password
        
        do {
            try managedContext.save()
            register.onNext([])
            
        } catch let customError {
            error.onNext(customError.localizedDescription)
        }
    }
    
    func login(mail: String, password: String) {
        loading.onNext(true)
        defer {
            loading.onNext(false)
        }
        guard let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            error.onNext(CoreDataError.contexNotFound.rawValue)
            return
        }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "mail == %@ AND password == %@", mail, password)
        
        do {
            guard let userObjects = try managedContext.fetch(fetchRequest) as? [User], !userObjects.isEmpty else {
                error.onNext(CoreDataError.dataNotFound.rawValue)
                return
            }
            login.onNext(userObjects)
        } catch let customError {
            error.onNext(customError.localizedDescription)
        }
    }
    
    func checkMailAvailable(mail: String) -> Bool {
        
        guard let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            return true
        }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "mail == %@", mail)
        //let request: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            guard let arrUsers = try managedContext.fetch(fetchRequest) as? [User] else {
                return true
            }
            debugPrint(arrUsers)
            return arrUsers.isEmpty
        } catch let customError {
            debugPrint(customError.localizedDescription)
            return true
        }
    }
    
    private func userCount() -> Int {
        guard let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            return 0
        }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        do {
            return try managedContext.fetch(fetchRequest).count
        } catch let customError {
            debugPrint(customError.localizedDescription)
        }
        return 0
    }
    
}
