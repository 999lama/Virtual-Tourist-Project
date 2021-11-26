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
    
    
    var longTapRecognizer = UILongPressGestureRecognizer()

    var pins =  [Pin]()
    
    @IBOutlet weak var mapView: MKMapView!{
        didSet{
            mapView.delegate = self
        }
    }
    
    
    let annotation = MKPointAnnotation()

    let lat = 24.774265
    let lon = 46.738586
  
    override func viewDidLoad() {
        super.viewDidLoad()
        pins = Pintore.shared.fetchAll()
        createAnnations(locations: pins)
        
        longTapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(setNewAnnotation))
        mapView.addGestureRecognizer(longTapRecognizer)
        UIDevice.printFolderPath()
}
    
    
    @objc func setNewAnnotation(){
        if longTapRecognizer.state == .began{
             // get the location
            let location = longTapRecognizer.location(in: mapView)
            
            // convert location to coordinate
            let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
            
            annotation.coordinate = coordinate
//            mapView.addAnnotation(annotation)
            addPin(annotation: annotation)
            }
        }
        
    func addPin( annotation: MKPointAnnotation){
        guard let pin = Pintore.shared.createPin(lat: annotation.coordinate.latitude, lon: annotation.coordinate.longitude) else {return}
        print("*******")
        print(Pintore.shared.fetchAll())
        pins.append(pin)
        self.createAnnations(locations: pins)
    }
   
    
    func createAnnations(locations : [Pin]){
        for location in locations {
            let annations = MKPointAnnotation()
            annations.title = location.id_
            annations.coordinate = CLLocationCoordinate2D(latitude:location.lat , longitude:  location.lon)
            mapView.addAnnotation(annations)
        
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay.isKind(of: MKCircle.self) {
            let view = MKCircleRenderer(overlay: overlay)
            view.fillColor = UIColor.black.withAlphaComponent(0.2)
            return view
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // TODO: by pressing on a pin go to photosListViewController
        mapView.deselectAnnotation(view.annotation! , animated: true)
        let lat = view.annotation!.coordinate.latitude
        let long = view.annotation!.coordinate.longitude
        APIManger.shared.request(lat: lat , long: long) { results in
            
            switch results{
            case .success(let images):
                if images != nil {
                    print(images)
                }
             print("sucessful request without founded images ")
            case .failure(let error):
                print(error)
            }
        }
        
       
//        let pin: Pin = view.annotation as! Pin
        
        let photosListVC = storyboard?.instantiateViewController(withIdentifier: "showPhoto") as! PhotoAlbumViewController
        photosListVC.annation = view.annotation as! MKPointAnnotation
        photosListVC.lat = view.annotation?.coordinate.latitude
        photosListVC.long = view.annotation?.coordinate.longitude

        navigationController?.pushViewController(photosListVC, animated: true)
    }
}

extension UIDevice {
    class func printFolderPath() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print("✅ \(documentsPath)")
    }
}
