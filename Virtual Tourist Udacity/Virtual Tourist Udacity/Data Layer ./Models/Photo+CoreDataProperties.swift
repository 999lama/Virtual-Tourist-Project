//
//  Photo+CoreDataProperties.swift
//  Virtual Tourist Udacity
//
//  Created by Lama Albadri on 18/12/2021.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var id_: String?
    @NSManaged public var imageurl: URL?
    @NSManaged public var image: Data?
    @NSManaged public var pin: Pin? // refrence from photo to pin

}

extension Photo : Identifiable {

}
