//
//  Constants.swift
//  AutoAMP
//
//  Created by Admin on 19/10/2017.
//  Copyright © 2017 etudiant. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Constants
{
    struct refs
    {
        static let databaseRoot = Database.database().reference()
        static let databaseChats = databaseRoot.child("chats")
    }
}
