//
//  Pin+CoreDataProperties.swift
//  Virtual Tourist Udacity
//
//  Created by Lama Albadri on 18/12/2021.
//
//

import Foundation
import CoreData


extension Pin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin")
    }

    @NSManaged public var id_: String?
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var photos: NSSet? // refrence from pin to photos

}

// MARK: Generated accessors for photos
extension Pin {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: Photo) // add single object

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: Photo)  // remove single object

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet) // add to photos/objects

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet) // remove from photos/objects

}

extension Pin : Identifiable {

}
