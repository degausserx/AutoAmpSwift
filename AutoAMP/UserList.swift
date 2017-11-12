//
//  UserList.swift
//  AutoAMP
//
//  Created by etudiant on 18/10/2017.
//  Copyright © 2017 etudiant. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth

class UserList {
    
    static var instance: UserList = UserList()
    
    private init() {
        
    }
    
    var data:[User] = []
    
    var students:[User] {
        return self.data.filter({
            !$0.isTeacher
        }).sorted()
    }
    
    var teachers:[User] {
        return self.data.filter({
            $0.isTeacher
        }).sorted()
    }
    
    var me: User! {
        let me = self.data.filter({ $0.userId == Auth.auth().currentUser!.uid })
        if me.count > 0 {
            return me[0]
        }
        return nil
    }
    
    var specificUsers: [User] {
        if let myself = self.me {
            if myself.isTeacher {
                return self.students
            }
            return self.teachers
        }
        return []
    }
    
    func find(_ id: String) -> User? {
        var user = self.data.filter({ $0.userId == id })
        return (user.isEmpty) ? nil : user[0]
    }
    
    func update(_ sender: UserListProtocol?) {
        FB.instance.getData("users/", completionHandler: {
            (data) in
            let newData = data as! Dictionary<String,AnyObject>
            self.data = []
            for (id, value) in newData {
                let general = value as! Dictionary<String,AnyObject>
                if let array = general["general"] {
                    let info = array as! Dictionary<String,AnyObject>
                    let firstName = info["firstName"] as! String
                    let lastName = info["lastName"] as! String
                    let isTeacher = info["isTeacher"] as! Bool
                    let lastOnline = info["lastOnline"] as! String
                    var user = User(id, first: firstName, last: lastName, teacher: isTeacher, online: lastOnline)
                    if let phone = info["phone"] as! String? {
                        user.phone = phone
                    }
                    self.data.append(user)
                }
            }
            if let delegate = sender {
                delegate.userListRefresh()
            }
        })
    }
    
}
