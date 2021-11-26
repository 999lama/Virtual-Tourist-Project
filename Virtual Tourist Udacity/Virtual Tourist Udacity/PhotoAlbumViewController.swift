//
//  PhotoAlbumViewController.swift
//  Virtual Tourist Udacity
//
//  Created by Lama Albadri on 24/09/2021.
//

import Foundation
import UIKit
import MapKit

class PhotoAlbumViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, MKMapViewDelegate , UICollectionViewDelegateFlowLayout{
    @IBOutlet weak var mapView: MKMapView!{
        didSet{
            mapView.delegate = self
        }
    }
    
    let activityView = UIActivityIndicatorView(style: .whiteLarge)
    
    var finalImages = [UIImage]()
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    var annation : MKPointAnnotation?
    var lat : Double?
    var long : Double?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .red
    }

    
    
    
    @IBAction func fetchNewClicked(_ sender: UIButton) {
        self.finalImages = []
        self.startAnimating()
        self.collectionView.reloadData()
        fetchRandomImages()

    }
    
    func configureMapView(){

        let location = CLLocation(latitude: self.lat!, longitude: self.long!)
        let center = CLLocationCoordinate2D(latitude: self.lat!, longitude: self.long!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        
        self.mapView.setRegion(region, animated: true)
        
        self.annation?.coordinate = location.coordinate
        self.mapView.addAnnotation(annation!)
    }
    
    func startAnimating() {
        
        let fadeView:UIView = UIView()
        fadeView.frame = self.view.frame
        fadeView.backgroundColor = .white
        fadeView.alpha = 0.4
        fadeView.tag = 5
        activityView.color = .red
        
        self.view.addSubview(fadeView)
        self.view.addSubview(activityView)
        activityView.hidesWhenStopped = true
        activityView.center = self.view.center
        activityView.startAnimating()
    }
    
    func stopAnimating(){
        if let viewWithTag = self.view.viewWithTag(5){
            viewWithTag.removeFromSuperview()
        }
        activityView.stopAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        startAnimating()
        configureMapView()
        fetchRandomImages()
     
    }
    
    func fetchRandomImages(){
        APIManger.shared.request(lat: lat!, long: long!) { results in
            switch results{
            case .success(let images):
                if images.count != 0 {
                    DispatchQueue.main.async {
                    for i in images {
                        
                        guard let imageURL = URL(string: i.url_m ?? String()) else {return}
        
                             let imageData = try? Data(contentsOf: imageURL)
        
                        guard let image = UIImage(data: imageData ?? Data()) else {return}
                        self.finalImages.append(image)
                        self.collectionView.reloadData()
                    }
                        self.stopAnimating()
                    self.collectionView.reloadData()
                }
                }
                print("Sucessfully with emopty resuls")
            case .failure(let error ):
                self.stopAnimating()
                    print(error)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if finalImages.count == 0 {
            self.collectionView.setEmptyMessage("Sorry We didn't found any photos for this location")

        }
            self.collectionView.restore()
            return finalImages.count
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoViewCell
   
        cell.imageView.image = finalImages[indexPath.row]
        
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width * 0.3 , height: self.view.frame.width * 0.3 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 4, left: 6, bottom: 4, right: 6)
    }
}

//MARK:- set Empty Message
extension UICollectionView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = #colorLiteral(red: 0.9253538847, green: 0.2691535056, blue: 0.2884525359, alpha: 1)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.boldSystemFont(ofSize: 17)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
