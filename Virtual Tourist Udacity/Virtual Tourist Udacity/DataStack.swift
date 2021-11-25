//
//  DataStack.swift
//  Virtual Tourist Udacity
//
//  Created by lama albadri on 05/10/2021.
//

import Foundation
import  CoreData
import UIKit

class DataStack {

    static let shared = DataStack()
    
    // MARK: Properties
    let persistentContainer: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    init() {
        persistentContainer = NSPersistentContainer(name: "Virtual_Tourist_Udacity")
        UIDevice.printFolderPath()
    }


    func saveContext(){
        if viewContext.hasChanges{
            do{
                try viewContext.save()
            }catch{
                debugPrint("Something when wrong while try to save context \(error.localizedDescription)")
            }
        }
    }
  
}
extension UIDevice {
    class func printFolderPath() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print("✅ \(documentsPath)")
    }
}
