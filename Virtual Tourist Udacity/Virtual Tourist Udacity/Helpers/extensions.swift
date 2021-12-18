//
//  extensions.swift
//  Virtual Tourist Udacity
//
//  Created by Lama Albadri on 18/12/2021.
//

import UIKit

extension UIDevice {
    class func printFolderPath() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print("✅ \(documentsPath)")
    }
}
