//
//  ViewController.swift
//  Virtual Tourist Udacity
//
//  Created by Lama Albadri on 21/09/2021.
//

import UIKit
import MapKit
import CoreData


class MapViewController: UIViewController  , MKMapViewDelegate ,UIGestureRecognizerDelegate{
    
    //MARK: - Properties
    var longTapRecognizer = UILongPressGestureRecognizer()
    let annotation = MKPointAnnotation()
    var pins =  [Pin]()
    
    
    //MARK: - @IBOutlets
    @IBOutlet weak var mapView: MKMapView!{
        didSet{
            mapView.delegate = self
        }
    }
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // fetch pins from core data
        pins = MangedStore.shared.fetchAll()
        // set the pins in the view
        createAnnations(locations: pins)
        // set long tap Recognizer
        longTapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(setNewAnnotation))
        // add the tap Recognizer to the mapView
        mapView.addGestureRecognizer(longTapRecognizer)
    }
    
    
    //MARK: - Helpers
    @objc func setNewAnnotation() {
        if longTapRecognizer.state == .began{
            // get the location
            let location = longTapRecognizer.location(in: mapView)
            
            // convert location to coordinate
            let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
            
            annotation.coordinate = coordinate
            // add the pin to map View
            addPin(annotation: annotation)
        }
    }
    
    func addPin(annotation: MKPointAnnotation) {
        // create the Pin in core data
        guard let pin = MangedStore.shared.createPin(lat: annotation.coordinate.latitude, lon: annotation.coordinate.longitude) else {return}
        // add pin to pins array
        pins.append(pin)
        // add pin to map view
        self.createAnnation(location: pin)
    }
    
    func createAnnation(location: Pin) {
        let annations = MKPointAnnotation()
        annations.title = location.id_
        annations.coordinate = CLLocationCoordinate2D(latitude:location.lat , longitude:  location.lon)
        mapView.addAnnotation(annations)
    }
    
    func createAnnations(locations : [Pin]) {
        for location in locations {
            let annations = MKPointAnnotation()
            annations.title = location.id_
            annations.coordinate = CLLocationCoordinate2D(latitude:location.lat , longitude:  location.lon)
            // add the pin to mapView
            mapView.addAnnotation(annations)
            
        }
    }
    
    //MARK: - mapView Delegate
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay.isKind(of: MKCircle.self) {
            let view = MKCircleRenderer(overlay: overlay)
            view.fillColor = UIColor.black.withAlphaComponent(0.2)
            return view
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation! , animated: true)
        guard let  lat = view.annotation?.coordinate.latitude else {return}
        guard let  long = view.annotation?.coordinate.latitude else {return}
        
        APIManger.shared.request(lat: lat , long: long) { results in
            
            switch results{
            case .success(let images):
                if images.count == 0 {
                    print("sucessfully request with 0 images Found ")
                } else {
                    print(images)
                }
            case .failure(let error):
                print(error)
            }
        }
        
        let photosListVC = storyboard?.instantiateViewController(withIdentifier: "showPhoto") as! PhotoAlbumViewController
        photosListVC.annation = view.annotation as? MKPointAnnotation
        photosListVC.lat = view.annotation?.coordinate.latitude
        photosListVC.long = view.annotation?.coordinate.longitude
        
        navigationController?.pushViewController(photosListVC, animated: true)
    }
}

