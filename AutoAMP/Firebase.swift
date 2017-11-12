//
//  Firebase.swift
//  AutoAMP
//
//  Created by etudiant on 10/10/2017.
//  Copyright © 2017 etudiant. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class FB {
    
    static var instance: FB = FB()
    var ref: DatabaseReference = Database.database().reference()
    var me: String {
        get {
            return Auth.auth().currentUser!.uid
        }
    }
    
    private init() {
        
    }
    
    func getData(_ childURL:String?, completionHandler: @escaping (Any?) -> ()) {
        var reference = self.ref
        if let url = childURL {
            reference = self.ref.child(url)
        }
        reference.observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            completionHandler(snapshot.value)
        }
    }
    
    func setData(_ object:Any, at path:String, completionHandler: ((Bool, DatabaseReference) -> ())?, errorHandler: ((Bool, DatabaseReference, String) -> ())?) {
        ref.child(path).setValue(object) { (error, reference) in
            if let e = error {
                if let completion = errorHandler {
                    completion(false, self.ref, e.localizedDescription)
                }
            }
            else {
                if let completion = completionHandler {
                    completion(true, self.ref)
                }
            }
        }
    }
    
    func delData(at path: String, completionHandler: ((Bool, DatabaseReference) -> ())?) {
        ref.child(path).removeValue(completionBlock: { error in
            if error.0 != nil {
                print("error occured")
            }
            else {
                if let completion = completionHandler {
                    completion(true, self.ref)
                }
            }
        })
    }
    
    func updateData(_ object:Any, at path:String, key: String, completionHandler: ((Bool, DatabaseReference) -> ())?, errorHandler: ((Bool, DatabaseReference, String) -> ())?) {
        ref.child(path).updateChildValues([key: object]) { (error, reference) in
            if let e = error {
                if let completion = errorHandler {
                    completion(false, self.ref, e.localizedDescription)
                }
            }
            else {
                if let completion = completionHandler {
                    completion(true, self.ref)
                }
            }
        }
    }
    
    func onlineUpdate() {
        if let userId = Auth.auth().currentUser?.uid {
            let newDate = DateTime()
            FB.instance.setData(newDate.getDateTime(), at: "users/\(userId)/general/lastOnline/", completionHandler: nil, errorHandler: nil)
        }
    }
    
}
