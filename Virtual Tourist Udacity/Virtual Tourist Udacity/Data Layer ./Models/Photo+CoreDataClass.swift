//
//  Photo+CoreDataClass.swift
//  Virtual Tourist Udacity
//
//  Created by Lama Albadri on 18/12/2021.
//
//

import Foundation
import CoreData

@objc(Photo)
public class Photo: NSManagedObject {

}

struct PhotoMapper {
    
    var id_ : String?
    var imageURL: URL?
    var image: Data?
    
    init(id_: String?, imageURL: URL?, image: Data? ) {
        self.id_ = id_
        self.image = image
        self.imageURL = imageURL
    }
}
