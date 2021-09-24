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
       print("heelllo")
        APIManger.shared.request(lat: lat, long: lon) { results in
            switch results{
            case .success(let images):
                print(images)
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
       

}
    
    
}

