//
//  TeacherUsersCollectionViewCell.swift
//  AutoAMP
//
//  Created by etudiant on 17/10/2017.
//  Copyright © 2017 etudiant. All rights reserved.
//

import UIKit

class TeacherUsersCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var OutletOnline: UILabel!
    @IBOutlet weak var OutletName: UILabel!
    
    var userId: String!
    var userData: User!
    var delegate: TeacherUsersCollectionViewController!
    
    func enableImage() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.clicked))
        singleTap.numberOfTapsRequired = 1
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(singleTap)
    }
    
    func clicked() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyboard.instantiateViewController(withIdentifier: "TeacherStudentInformation") as! TeacherStudentViewController
        newViewController.student = userData
        delegate.navigationController?.pushViewController(newViewController, animated: true)
    }
}
