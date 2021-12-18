//
//  PhotoAlbumViewController.swift
//  Virtual Tourist Udacity
//
//  Created by Lama Albadri on 24/09/2021.
//

import Foundation
import UIKit
import MapKit

class PhotoAlbumViewController : UIViewController, MKMapViewDelegate {
    
    //MARK: - @IBOutlets
    
    @IBOutlet weak var emptyView: UIView! {
        didSet {
            emptyView.isHidden = true
        }
    }
    @IBOutlet weak var mapView: MKMapView!{
        didSet{
            mapView.delegate = self
        }
    }
    
    @IBOutlet weak var deletebtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    //MARK: - Properties
    let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    var finalImages = [UIImage]()
    var annation : MKPointAnnotation?
    var lat : Double?
    var long : Double?
    var selectedToDelete:[Int] = []
    var photos: [Photo]? = []
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMapView()
        fetchPhotos()
    }
    
    
    //MARK: - @IBActions
    @IBAction func fetchNewClicked(_ sender: UIButton) {
        self.finalImages = []
        self.photos = []
        fetchPhotos()
    }
    
    //MARK: - Helpers
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
        activityView.color = .systemBlue
        self.view.addSubview(fadeView)
        self.view.addSubview(activityView)
        activityView.hidesWhenStopped = true
        activityView.center = self.view.center
        activityView.startAnimating()
    }
    
    func stopAnimating() {
        if let viewWithTag = self.view.viewWithTag(5){
            viewWithTag.removeFromSuperview()
        }
        activityView.stopAnimating()
    }
    
    
    func fetchPhotos() {
        startAnimating()
        guard let lat = self.lat , let long = self.long else {
            return
        }
        if let photos = MangedStore.shared.fetchPhotos(lat: lat, long: long) {
            if photos.count == 0 {
                fetchPhotosAPI()
            } else {
                self.photos = photos
                self.appendToImageArray(photos: photos)
                
            }
        } else {
            fetchPhotosAPI()
        }
        self.collectionView.reloadData()
    }
    
    func appendToImageArray(photos : [Photo]) {
        for photo in photos {
            guard let image = UIImage(data: photo.image ?? Data()) else {return}
            self.finalImages.append(image)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.stopAnimating()
            }
        }
    }
    
    
    func fetchPhotosAPI(){
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
                            guard let lat = self.lat , let long = self.long else {
                                return
                            }
                            MangedStore.shared.addPhoto(with: lat, lon: long, photo: PhotoMapper(id_: i.title, imageURL: imageURL, image: imageData))
                            
                            self.stopAnimating()
                            self.collectionView.reloadData()
                        }
                        
                    }
                    self.fetchPhotos()
                } else {
                    // show empty view
                    self.emptyView.isHidden = false
                    print("Sucessfully with empty resuls")
                    self.stopAnimating()
                }
            case .failure(let error ):
                self.stopAnimating()
                print(error)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        deletebtn.isHidden = false
        selectedToDelete = selectedToDeleteFromIndexPath(collectionView.indexPathsForSelectedItems!)
        let cell = collectionView.cellForItem(at: indexPath)
        DispatchQueue.main.async {
            cell?.contentView.alpha = 0.4
        }
        
    }
    
    @IBAction func deleteSelected(_ sender: Any) {
        deletebtn.isHidden = true
        
        if let selected: [IndexPath] = collectionView.indexPathsForSelectedItems {
            
            collectionView.deleteItems(at: selected)
            
        }
        self.finalImages = []
        self.photos = []
        fetchPhotos()
        
    }
    
    // helper func to delete selected photos
    func selectedToDeleteFromIndexPath(_ indexPathArray: [IndexPath]) -> [Int] {
        var selected: [Int] = []
        for indexPath in indexPathArray {
            if let photo = photos?[indexPath.row] {
                MangedStore.shared.deletePhoto(photo: photo)
            }
            selected.append(indexPath.item)
        }
        
        return selected
    }
    
    
}


//MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension PhotoAlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return finalImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoViewCell
        
        cell.imageView.image = finalImages[indexPath.row]
        return cell
    }
    
}

extension PhotoAlbumViewController:  UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width , height: self.view.frame.width )
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
