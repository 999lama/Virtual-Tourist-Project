//
//  PinStore.swift
//  Virtual Tourist Udacity
//
//  Created by Lama Albadri on 26/11/2021.
//

import Foundation
import UIKit
import CoreData

class MangedStore {
    
    static let shared = MangedStore()
    
    let coreDataStack: CoreDataStack = {
        return CoreDataStack.shared
    }()
    
     //MARK:- CRUD
    func createPin(lat: Double , lon: Double) -> Pin? {
        var pin: Pin?
        if let entiryDesciption = NSEntityDescription.entity(forEntityName: "Pin", in: coreDataStack.managedObjectContext) {
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
        let predicate = NSPredicate(format: "id_='\(lat)\(lon)'")
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
    

    func addPhoto(with lat: Double, lon:Double , photo: PhotoMapper) {
        if let pin = self.fetchPin(lat: lat, lon: lon) {
            if let photoFound = self.fetchPhoto(id_: photo.id_ ?? "") {
                return
            } else {
                var photoObject = Photo(context: CoreDataStack.shared.managedObjectContext)
                photoObject.id_ = "\(lat)\(lon)"
                photoObject.imageurl = photo.imageURL
                photoObject.image = photo.image
                
                pin.addToPhotos(photoObject)
                // save context
                do {
                    try? CoreDataStack.shared.managedObjectContext.save()
                } catch {
                    print("Error while try to save in core Data Stack")
                }
            }
            
        }
    }
  
    func fetchPhoto(id_: String) -> Photo? {
        let FR: NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "id_='\(id_)'")
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
   
    
      func fetchPhoto(image: String) -> Photo? {
          let FR: NSFetchRequest<Photo> = Photo.fetchRequest()
          let predicate = NSPredicate(format: "image'\(image)'")
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
     
    
    
    func deletePhoto(photo: Photo) {
            coreDataStack.managedObjectContext.delete(photo)
            coreDataStack.saveContext()
    }
    func fetchPhotos(lat: Double, long: Double) -> [Photo]? {
        let FR: NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "id_='\(lat)\(long)'")
        FR.predicate = predicate
        do {
            let photos = try coreDataStack.managedObjectContext.fetch(FR)
            return photos
        } catch  {
           print("\(error.localizedDescription)")
        }
        return nil
    }
}


