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
 
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
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
        navigationItem.leftBarButtonItem = editButtonItem
    
    }

    @IBAction func deleteItem(_ sender: Any) {
        if let selectedCells = collectionView.indexPathsForSelectedItems {
            let items = selectedCells.map { $0.item }.sorted().reversed()
            for item in items {
                finalImages.remove(at: item)
            }
            collectionView.deleteItems(at: selectedCells)
            deleteButton.isEnabled = false
        }
    }
    
    
    
    @IBAction func fetchNewClicked(_ sender: UIButton) {
        self.finalImages = []
        startAnimating()
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
    
    func startAnimating(){
        
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
                        let imageURL = URL(string: i.url_m!)
        
                            let imageData = try! Data(contentsOf: imageURL!)
        
                        let image = UIImage(data: imageData)
                        self.finalImages.append(image!)
                        self.collectionView.reloadData()
                    }
                        self.stopAnimating()
                    self.collectionView.reloadData()
                }
                }
                print("Sucessfully with emopty resuls")
            case .failure(let error ):
                    print(error)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        collectionView.allowsMultipleSelection = editing
        let indexPaths = collectionView.indexPathsForVisibleItems
        for indexPath in indexPaths {
            let cell = collectionView.cellForItem(at: indexPath) as! PhotoViewCell
            cell.isInEditingMode = editing
        }
    }
    
    // 1
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isEditing {
            deleteButton.isEnabled = false
        } else {
            deleteButton.isEnabled = true
        }
    }

    // 2
     func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let selectedItems = collectionView.indexPathsForSelectedItems, selectedItems.count == 0 {
            deleteButton.isEnabled = false
        }
    }
    
}
