//
//  EnoteCoredataManagerClass.swift
//  Enote
//

//

import Foundation
import CoreData
import UIKit

class QCCoredataManagerClass{
    static var shared:QCCoredataManagerClass = QCCoredataManagerClass()
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "ENotes")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

struct QCCoredataOperations{
    
    
    func  saveNote(title:String,content:String,result: @escaping (_ resultItem:Bool)->Void){
        
        
        let dispatchQueue = DispatchQueue(label: "ENoteAddBG", qos: .background)
        dispatchQueue.async{
            QCCoredataManagerClass.shared.persistentContainer.performBackgroundTask { (managed_Context) in
                let noteDetailsEntity = NSEntityDescription.entity(forEntityName: "NoteMaster", in: managed_Context)!
                
                
                //SAVE CONTACT DETAILS
                let noteItem:NoteMaster = NSManagedObject(entity: noteDetailsEntity, insertInto: managed_Context) as! NoteMaster
                noteItem.title = title
                noteItem.content = content
                noteItem.timeStamp = Date()
                noteItem.id = UUID().uuidString
                
                
                
                
                if managed_Context.hasChanges {
                    do {
                        try  managed_Context.save()
                        result(true)
                    } catch {
                        // let nserror = error as NSError
                        //fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                        
                    }
                }
                else{
                    result(false)
                }
            }
        }
        
    }
    func getAllNoteList()->[NoteMaster]{
        let contactMainListFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "NoteMaster")
        contactMainListFetch.resultType  = .managedObjectResultType
        // contactMainListFetch.propertiesToFetch = ["id","name","phone"]
        var dbResult:[NoteMaster] = []
        if let result:[NoteMaster] = try! QCCoredataManagerClass.shared.persistentContainer.viewContext.fetch(contactMainListFetch) as? [NoteMaster] {
            for item in result {
                dbResult.append(item)
            }
        }
        return dbResult
        
    }
    
    func getAllNoteList(completionHandlerWithJson: @escaping (_ contactDBResult:[NoteMaster]) -> Void) {
       let result =  getAllNoteList()
       completionHandlerWithJson(result)
    }
    
    
    
    func updateRecordBy(title:String,Content:String,id:String ,delResult: @escaping (_ result:Bool) -> Void){
        
        let dispatchQueue = DispatchQueue(label: "ENoteUpdBG", qos: .background)
        dispatchQueue.async{
            //QDMSCoredataManagerClass.shared.persistentContainer.performBackgroundTask { (managed_Context) in
            
            QCCoredataManagerClass.shared.persistentContainer.performBackgroundTask {
                (managed_Context) in
                let notes: NoteMaster!
                
                        let request = NoteMaster.fetchRequest()
                    request.predicate = NSPredicate(format: "%K == %@", "id", id)
                if  let items = try? managed_Context.fetch(request) {
                    
                    if items.count == 0 {
                        delResult(false)
                    } else {
                        // here you are updating
                        notes = items.first
                        notes.content = Content
                        notes.title = title
                    }
                }
                
                do {
                    try managed_Context.save()
                    delResult(true)
                }
                catch {
                    delResult(false)
                    //  let nserror = error as NSError
                    //fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
        
    }
    func deleteAllRecordsByTimeStamp(id:String,delResult: @escaping (_ result:Bool) -> Void){
        let dispatchQueue = DispatchQueue(label: "ENoteDelBG", qos: .background)
        dispatchQueue.async{
            //QDMSCoredataManagerClass.shared.persistentContainer.performBackgroundTask { (managed_Context) in
            
            QCCoredataManagerClass.shared.persistentContainer.performBackgroundTask { (managed_Context) in
                let fetchRequest1:NSFetchRequest<NSFetchRequestResult> = NoteMaster.fetchRequest()
                
                let companyAddrFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "NoteMaster")
                companyAddrFetch.predicate = NSPredicate(format: "id = %@", id)
                
                let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: companyAddrFetch)
                
                do {
                    try managed_Context.execute(batchDeleteRequest1)
                    try  managed_Context.save()
                    delResult(true)
                    
                    //  self.saveBookMarks(documentsData: documentsData)
                } catch {
                    delResult(false)
                    //  let nserror = error as NSError
                    //fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
                
            }
            
            //}
        }
        
        
    }
}
