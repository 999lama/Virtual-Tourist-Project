//
//  PhotoAlbumViewController.swift
//  Virtual Tourist Udacity
//
//  Created by Lama Albadri on 24/09/2021.
//

import Foundation
import UIKit
import MapKit

class PhotoAlbumViewController : UIViewController{
    
    var annation : MKPointAnnotation?
    var lat : Double?
    var long : Double?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("-------- lat" , lat)
        print("-------- long" , long)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("-------- lat" , lat)
        print("-------- long" , long)
        
        APIManger.shared.request(lat: lat!, long: long!) { results in
            switch results{
            case .success(let images):
                if images != nil {
                    print(images)
                }
                print("Sucessfully with emopty resuls")
            case .failure(let error ):
                    print(error)
            }
        }
    }
}
