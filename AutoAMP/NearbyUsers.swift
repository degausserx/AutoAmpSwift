//
//  NearbyUsers.swift
//  AutoAMP
//
//  Created by etudiant on 17/10/2017.
//  Copyright © 2017 etudiant. All rights reserved.
//

import Foundation

class NearbyUsers: Equatable {
    
    static var Users: [NearbyUsers] = []
    
    let userId: String
    
    init(_ user: String) {
        self.userId = user
    }
    
    static func ==(lhs: NearbyUsers, rhs: NearbyUsers) -> Bool {
        return lhs.userId == rhs.userId
    }

}
