//
//  PhotoViewCell.swift
//  Virtual Tourist Udacity
//
//  Created by Lama Albadri on 24/09/2021.
//

import UIKit

class PhotoViewCell: UICollectionViewCell {
    
    @IBOutlet weak var checkmarkLabel: UILabel!{
        didSet{
            checkmarkLabel.textColor = .white
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    
    var isInEditingMode: Bool = false {
        didSet {
            checkmarkLabel.isHidden = !isInEditingMode
        }
    }
    
    // 2
    override var isSelected: Bool {
        didSet {
            if isInEditingMode {
                checkmarkLabel.text = isSelected ? "✓" : ""
                checkmarkLabel.textColor = .white
            }
        }
    }
}
