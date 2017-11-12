//
//  StudentTabBarController.swift
//  AutoAMP
//
//  Created by etudiant on 17/10/2017.
//  Copyright © 2017 etudiant. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import CoreLocation

class StudentTabBarController: UITabBarController, UITabBarControllerDelegate, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    static var currentLocation: [String : Any] = [:]
    static var locationObject: CLLocation?
    let userId: String = (Auth.auth().currentUser?.uid)!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.tabBar.items![1].title = "Teachers"
        self.tabBar.items![0].title = "Bookings"
        
        updateOnline()
        UserList.instance.update(nil)
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    override func viewWillDisappear(_ animated: Bool) {

    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        updateLocation()
        updateOnline()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc:CLLocationCoordinate2D = manager.location!.coordinate
        StudentTabBarController.locationObject = manager.location!
        let theTime = DateTime().getDateTime()
        var update: Bool = false
        if StudentTabBarController.currentLocation.count == 0 {
            update = true
        }
        StudentTabBarController.currentLocation = [
            "time": theTime,
            "latitude": loc.latitude,
            "longitude": loc.longitude,
            "isTeacher": false
        ]
        if (update) {
            self.updateLocation()
        }
    }
    
    func updateLocation() {
        if (StudentTabBarController.currentLocation.count == 4) {
            FB.instance.updateData(StudentTabBarController.currentLocation, at: "user_locations", key: (self.userId), completionHandler: nil, errorHandler: nil)
        }
    }

    func updateOnline() {
        FB.instance.setData(DateTime().getDateTime(), at: "users/\(self.userId)/general/lastOnline/", completionHandler: nil, errorHandler: nil)
    }
}
