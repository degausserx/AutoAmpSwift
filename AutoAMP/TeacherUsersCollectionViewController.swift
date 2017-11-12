//
//  TeacherUsersCollectionViewController.swift
//  AutoAMP
//
//  Created by etudiant on 17/10/2017.
//  Copyright © 2017 etudiant. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class TeacherUsersCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UserListProtocol {
    
    var refreshControl: UIRefreshControl!
    var studentList: [User] = []

    @IBOutlet weak var UserCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.UserCollection.delegate = self
        self.UserCollection.dataSource = self

        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(userListRefresh), for: .valueChanged)
        UserCollection.refreshControl = refreshControl

        UserList.instance.update(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.studentList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UserCollection.dequeueReusableCell(withReuseIdentifier: "TeacherUsersCell2", for: indexPath) as! TeacherUsersCollectionViewCell
        let data = self.studentList[indexPath.row]
        let dt = DateTime()
        let difference = dt.setFromString(data.lastOnline).getNumeric().timeIntervalSinceNow
        let color = (-difference < (60 * 60 * 12)) ? Colors.Green : Colors.Red
        cell.OutletName.text = data.firstName
        cell.OutletOnline.backgroundColor = UIColor(hex: color)
        cell.userId = data.userId
        cell.userData = data
        cell.delegate = self
        cell.enableImage()
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let minus = (UIDeviceOrientationIsPortrait(UIDevice.current.orientation)) ? (20, 3) : (40, 5)
        let cellSize = ((collectionView.bounds.size.width - CGFloat(minus.0)) / CGFloat(minus.1))
        return CGSize(width: cellSize, height: cellSize)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        UserCollection.reloadData()
    }
    
    func userListRefresh() {
        self.studentList = UserList.instance.specificUsers
        if self.studentList.count > 0 {
            self.title = (self.studentList[0].isTeacher) ? "Teachers" : "Students"
        }
        else {
            self.title = "Users"
        }
        self.refreshControl.endRefreshing()
        self.UserCollection.reloadData()
    }
    
}
