//
//  TeacherTabBarController.swift
//  AutoAMP
//
//  Created by etudiant on 17/10/2017.
//  Copyright © 2017 etudiant. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import CoreLocation

class TeacherTabBarController: UITabBarController, UITabBarControllerDelegate, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    static var currentLocation: [String : Any] = [:]
    static var locationObject: CLLocation?
    let userId: String = (Auth.auth().currentUser?.uid)!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
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

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        updateLocation()
        updateOnline()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("update")
        let loc:CLLocationCoordinate2D = manager.location!.coordinate
        TeacherTabBarController.locationObject = manager.location!
        let theTime = DateTime().getDateTime()
        var update: Bool = false
        if TeacherTabBarController.currentLocation.count == 0 {
            update = true
        }
        TeacherTabBarController.currentLocation = [
            "time": theTime,
            "latitude": loc.latitude,
            "longitude": loc.longitude,
            "isTeacher": true
        ]
        if (update) {
            self.updateLocation()
        }
    }
    
    func updateLocation() {
        if (TeacherTabBarController.currentLocation.count == 4) {
            FB.instance.updateData(TeacherTabBarController.currentLocation, at: "user_locations", key: (self.userId), completionHandler: nil, errorHandler: nil)
        }
    }
    
    func updateOnline() {
        FB.instance.setData(DateTime().getDateTime(), at: "users/\(self.userId)/general/lastOnline/", completionHandler: nil, errorHandler: nil)
    }
    
}
