//
//  TeacherStudentViewController.swift
//  AutoAMP
//
//  Created by Admin on 19/10/2017.
//  Copyright © 2017 etudiant. All rights reserved.
//

import UIKit

class TeacherStudentViewController: UIViewController, LocationProtocol {
    
    var student: User!
    var shareLocation: Location!
    
    var isSharingLocation: Bool = false
    var canViewLocation: Bool = false

    @IBOutlet weak var ImageOutlet: UIImageView!
    @IBOutlet weak var OutletLabelName: UILabel!
    @IBOutlet weak var OutletButtonSchedule: UIButton!
    @IBOutlet weak var OutletButtonLocation: UIButton!
    
    @IBAction func OutletButtonShareLocation(_ sender: Any) {
        let alert = UIAlertController(title: "Share location", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let option = (self.isSharingLocation) ? "Unshare your location" : "Share your location"
        
        alert.addAction(UIAlertAction(title: option, style: .destructive, handler: {
            action in
            self.shareLocation.shareMyLocation(!self.isSharingLocation)
            self.isSharingLocation = !self.isSharingLocation
        }))
        if (self.canViewLocation) {
            alert.addAction(UIAlertAction(title: "View user location", style: .destructive, handler: {
                action in
                self.shareLocation.getOtherLocation(self)
            }))
        }
        alert.addAction(UIAlertAction(title: "Close", style: .destructive, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func ActionViewSchedule(_ sender: UIButton) {
        goto("StudentScheduleViewController")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "User profile"

        self.OutletLabelName.text = "\(self.student.firstName) \(self.student.lastName)"
        self.OutletButtonSchedule.backgroundColor = UIColor(hex: Colors.Purple)
        self.OutletButtonLocation.backgroundColor = UIColor(hex: Colors.Red)
        if (!self.student.isTeacher) {
            self.OutletButtonSchedule.isHidden = true
        }
        
        shareLocation = Location(FB.instance.me, other: self.student.userId)
        shareLocation.checkShare(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    func goto(_ page: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if (page == "StudentScheduleViewController") {
            let controller = storyboard.instantiateViewController(withIdentifier: page) as! StudentScheduleViewController
            controller.teacher = student
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func locationDataDownloaded() {
        self.canViewLocation = shareLocation.userCanView
        self.isSharingLocation = shareLocation.userCanBeViewed
    }
    
    func locationCoordinatesDownloaded(lat: Double, long: Double) {
        print("latitude: \(lat) :: longitude: \(long)")
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        controller.latitude = lat
        controller.longitude = long
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
