//
//  MapViewController.swift
//  AutoAMP
//
//  Created by Admin on 21/10/2017.
//  Copyright © 2017 etudiant. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    var latitude: Double!
    var longitude: Double!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: self.latitude, longitude: self.longitude, zoom: 14.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        // Creates a marker in the center of the map.
        let line = GMSPolyline()
            line.strokeColor = UIColor(hex: Colors.Blue)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        marker.title = ""
        marker.snippet = ""
        marker.map = mapView
    }

}
