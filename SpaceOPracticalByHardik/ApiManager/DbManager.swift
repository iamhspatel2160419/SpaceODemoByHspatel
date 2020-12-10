import UIKit
import CoreData

open class DbManager
{
    static let sharedDbManager = DbManager()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    init()
    {
        
    }
    var dictAttributes : NSDictionary!
    
    
    
//    let dictInsertRatings = NSMutableDictionary.init(dictionary: RatingItem as! NSDictionary)
//    dictInsertRatings.setValue(dictInsertRatings.object(forKey: ""), forKey: "")
//    dictInsertRatings.setValue(dictInsertRatings.object(forKey: ""), forKey: "")
//    DbManager.sharedDbManager.insertIntoTable(tableNam
    
    
    
    func insertIntoTable(_ tblName:String,dictInsertData:NSDictionary)
    {
        let managedObject  = NSEntityDescription.insertNewObject(forEntityName: tblName, into: appDelegate.managedObjectContext)
        let entity = managedObject.entity
        dictAttributes = entity.attributesByName as NSDictionary
        for (key, _) in dictAttributes
        {
            var entityValue : AnyObject
            let tempKey = (key as!String).firstCharacterUpperCase()
            if let val = dictInsertData.object(forKey: key)
            {
                entityValue = val as AnyObject
                if entityValue is NSNull
                {
                    
                }
                else
                {
                    managedObject.setValue(entityValue, forKey: key  as! String)
                }
                
            }
            else if ((dictInsertData[tempKey]) != nil )
            {
                entityValue = dictInsertData.object(forKey: tempKey)! as AnyObject
                if entityValue is NSNull
                {
                    
                }
                else
                {
                    managedObject.setValue(entityValue, forKey: key  as! String)
                }
            }
        }
        do
        {
            let appdel = UIApplication.shared.delegate as! AppDelegate
            try appdel.managedObjectContext.save()
            
        }
        catch let error as NSError
        {
            print("Could not save \(error), \(error.userInfo)")
            
        }
        
    }
//    let bothDayPredicate =
//        NSPredicate(format: "anniversary contains[c] %@ AND birthday contains[c] %@","\(dateString)","\(dateString)")
//    let anniversaryPredicate = NSPredicate(format: "anniversary contains[c] %@","\(dateString)")
//    let birthdayPredicate = NSPredicate(format: "birthday contains[c] %@","\(dateString)")
//    let compundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [bothDayPredicate,anniversaryPredicate,birthdayPredicate])
//
//    DbManager.sharedDbManager.fetchDataFrom(tableName.Retailer,
//                                                                         strPredicate: compundPredicate)
//    { (result) in
//        if result.count > 0
//        {
//            for k in 0..<result.count
//            {
//                let objRetailer = result[k] as! ClassName
//
    
    
    func fetchDataFromTable(_ tbleName:String,
                            strPredicate:NSPredicate,
                            completion: (_ result: NSArray)->())
    {
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: tbleName)
        fetchRequest.predicate = strPredicate
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            completion(results as NSArray)
            //print(results)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    func clearTable(_ entity: String)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        // let fetchRequest = NSFetchRequest(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            
            for manageObjects in results {
                appDelegate.managedObjectContext.delete(manageObjects as! NSManagedObject)
                try appDelegate.managedObjectContext.save()
                //print(manageObjects)
            }
            
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
    func deleteSelectedId(_ entity: String,strPredicate:String)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        if !strPredicate.isEmpty
        {
            fetchRequest.predicate = NSPredicate(format: strPredicate)
        }
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            fetchRequest.returnsObjectsAsFaults = false
            for manageObjects in results {
                appDelegate.managedObjectContext.delete(manageObjects as! NSManagedObject)
                try appDelegate.managedObjectContext.save()
                //print(manageObjects)
            }
        } catch let error as NSError
        {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
}
