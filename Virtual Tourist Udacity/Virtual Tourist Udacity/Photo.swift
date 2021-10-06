//
//  Photo.swift
//  Virtual Tourist Udacity
//
//  Created by lama albadri on 05/10/2021.
//

import Foundation

struct PhotosObject : Codable {
    var photos : Photo
    
}

struct Photo : Codable {
    var photo : [ImageUrls]
}

struct ImageUrls : Codable {
    var title : String?
    var url_z : String?
    var url_m : String?
    var latitude : String?
    var longitude : String?
    
}
