 //
//  ViewController.swift
//  Virtual Tourist Udacity
//
//  Created by Lama Albadri on 21/09/2021.
//

import UIKit

class ViewController: UIViewController {

    let lat = 24.774265
    let lon = 46.738586
    var photoArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        APIManger.shared.fetchPhotoForLocation(lat: lat, lon: lon) { (photos) in
           
            switch photos{
            case .success(let photos):
                self.photoArray.forEach { (photo) in
                    print("phot url is \(photo)")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }


}
}

