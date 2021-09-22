//
//  Constants.swift
//  Virtual Tourist Udacity
//
//  Created by Lama Albadri on 21/09/2021.
//

import Foundation


struct URLComponent {
    
    static let basURL = "https://www.flickr.com/services/rest/"
    static let method = "flickr.photos.search"
    static let apiKey = "f6c977c7859465da312c72cf112e34ca"
    static let hasGeo = "1"
    static let extras = "url_z,geo"
    static let format = "json"
}
