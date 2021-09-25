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
     let per_page = 30
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
                              "nojsoncallback" : URLComponent.nojsoncallback,
                              "geo_context": URLComponent.geoContext,
                              "per_page" : "\(per_page)",
                              "page" : "\(Int.random(in: 1...20))"
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
    
    
    //MARK: 1- Configure the session
       private let session : URLSession = {
           let configure = URLSessionConfiguration.default
           return URLSession(configuration: configure)
       }()
    
    //MARK: 2- make the request
    func request(lat : Double , long : Double ,completion: @escaping (Result<[ImageUrls], Error>) -> Void) {
        
        let url = flickerUrl(lat: String(lat), lon: String(long))
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) in

            let result = self.checkTheData(data: data, error: error)

            OperationQueue.main.addOperation {
                completion(result)
         print(result)
            }
          
        }
        task.resume()
        
    }
    
    func fetchPhotoWithRandomPages(url : String , completionHandler :  @escaping (Result<[ImageUrls], Error>) -> Void){
        
        
    }
    
    //MARK: 3- check the data
    func checkTheData(data: Data? , error : Error? ) -> Result<[ImageUrls], Error> {
        
        guard let isonData = data else {
            return .failure(error!)
        }
        
        return parseManger(fromJSON: isonData)
    }
    
    //MARK: 4- parse the JISON
        func parseManger(fromJSON data: Data) -> Result<[ImageUrls], Error> {
            
            do {
                let decoder = JSONDecoder()
                
                let senatorsResponse = try decoder.decode(PhotosObject.self, from: data)
                
                let photos = senatorsResponse.photos.photo
                
                
                
                return .success(photos)
            } catch let error {
                
                
                return .failure(error)
            }
            
        }
    

        
}


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
