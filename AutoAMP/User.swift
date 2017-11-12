//
//  User.swift
//  AutoAMP
//
//  Created by etudiant on 18/10/2017.
//  Copyright © 2017 etudiant. All rights reserved.
//

import Foundation

struct User: Comparable, Equatable {
    var firstName: String
    var lastName: String
    var isTeacher: Bool
    var lastOnline: String
    var userId: String
    var phone: String = ""
    
    init(_ id: String, first: String, last: String, teacher: Bool, online: String) {
        self.userId = id
        self.firstName = first
        self.lastName = last
        self.isTeacher = teacher
        self.lastOnline = online
    }
    
    static func <(left: User, right: User) -> Bool {
        return left.lastOnline > right.lastOnline
    }
    
    static func ==(left: User, right: User) -> Bool {
        return left.lastOnline == right.lastOnline
    }
}
