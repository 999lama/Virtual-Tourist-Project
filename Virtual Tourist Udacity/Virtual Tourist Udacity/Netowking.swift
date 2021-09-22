//
//  Netowking.swift
//  Virtual Tourist Udacity
//
//  Created by Lama Albadri on 21/09/2021.
//

import Foundation
import UIKit

class APIManger {
    
    static let shared = APIManger()
    
    static let lat = 24.774265
    static let lon = 46.738586
    
    //MARK: - making the URL
     func flickerUrl(lat : String, lon : String) -> URL {
        
        var components = URLComponents(string: URLComponent.basURL)
        
        let baseParameters = ["method" : URLComponent.method,
                              "api_key" : URLComponent.apiKey,
                              "has_geo" : URLComponent.hasGeo,
                              "lat" : "\(lat)",
                              "lon" : "\(lon)",
                              "extras" : URLComponent.extras,
                              "format" : URLComponent.format,
                              "nojsoncallback" : "1"
        ]
        
        var queryItems = [URLQueryItem]()
        
        for (key, value) in baseParameters {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        
        components!.queryItems = queryItems
        let url = components!.url!
        return url
        
    }
    
    func fetchPhotoForLocation(lat: Double , lon : Double, completion :  @escaping (_ urls : [String]?, _ error : Error?) -> ()){
        
        let url = flickerUrl(lat: String(lat), lon: String(lon))
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let httpsResponse = response as? HTTPURLResponse{
                print("StatusCode : \(httpsResponse.statusCode)")
            }
            
            // --- Convert the data to our model ----
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    do {
                        
                        if let imageData = data {
                            let jsonData = try JSONDecoder().decode(FlickrApi.self, from: imageData)
                            
                            var urls = [String]()
                            for i in jsonData.photo.photo{
                                if let imageURL = i.url_z{
                                    urls.append(imageURL)
                                }
                            }
                            
                            completion(urls, nil)
                            
                        }
                    }catch {
                        
                        completion(nil, error)
                    }
                }
            }.resume()
    }
    
    
    
}


struct FlickrApi : Codable {
    let photo : Photo
}

struct Photo : Codable {
    let photo : [ImageUrls]
}

struct ImageUrls : Codable {
    let url_z : String?
}
