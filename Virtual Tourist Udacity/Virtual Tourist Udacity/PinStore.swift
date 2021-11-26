//
//  PinStore.swift
//  Virtual Tourist Udacity
//
//  Created by Lama Albadri on 26/11/2021.
//

import Foundation
import UIKit
import CoreData

class Pintore {
    
    static let shared = Pintore()
    
    let coreDataStack: CoreDataStack = {
        return CoreDataStack.shared
    }()
    
     //MARK:- CRUD
    func createPin(lat: Double , lon: Double) -> Pin? {
        var pin: Pin?
        if let entiryDesciption = NSEntityDescription.entity(forEntityName: "Pin", in: coreDataStack.managedObjectContext){
            let newPin =  NSManagedObject(entity: entiryDesciption, insertInto: coreDataStack.managedObjectContext) as? Pin
            newPin?.id_ = "\(lat)\(lon)"
            newPin?.lon = lon
            newPin?.lat = lat
            coreDataStack.saveContext()
            pin = newPin
            
        }
        return pin
    }
    
 
    func fetchAll() -> [Pin]{
        let FR: NSFetchRequest<Pin> = Pin.fetchRequest()
        var resulst:[Pin] = []
        do {
            resulst = try coreDataStack.managedObjectContext.fetch(FR)
        } catch  {
           print(error.localizedDescription)
        }
        return resulst
    }
    
    
    func deleteAll(){
        let FR: NSFetchRequest<Pin> = Pin.fetchRequest()
        do {
            let results = try coreDataStack.managedObjectContext.fetch(FR)
            for result in results {
                coreDataStack.managedObjectContext.delete(result)
            }
            coreDataStack.saveContext()
            print("All data deleted suessfully")
        } catch  {
            print(error.localizedDescription)
        }
    }
    

    func fetchPin(lat: Double , lon : Double) -> Pin? {
        let FR: NSFetchRequest<Pin> = Pin.fetchRequest()
        let predicate = NSPredicate(format: "id='\(lat)\(lon)'")
        FR.predicate = predicate
        do {
            let results = try coreDataStack.managedObjectContext.fetch(FR)
            let pin = results.first
            return pin
        } catch  {
           print("\(error.localizedDescription)")
        }
        return nil
    }
    
}


