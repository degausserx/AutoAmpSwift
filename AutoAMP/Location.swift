//
//  Location.swift
//  AutoAMP
//
//  Created by etudiant on 23/10/2017.
//  Copyright © 2017 etudiant. All rights reserved.
//

import Foundation

class Location {
    
    var userId: String!
    var otherId: String!
    
    var userCanBeViewed: Bool = false
    var userCanView: Bool = false
    
    init(_ user: String, other: String) {
        self.userId = user
        self.otherId = other
    }
    
    func checkShare(_ sender: LocationProtocol) {
        FB.instance.getData("shared_locations/\(self.userId!)/\(self.otherId!)/", completionHandler: {
            value in
            if (value is NSNull) {
                self.userCanView = false
            }
            else {
                let newValue = value as! Bool
                self.userCanView = newValue
            }
            FB.instance.getData("shared_locations/\(self.otherId!)/\(self.userId!)/", completionHandler: {
                value in
                if (value is NSNull) {
                    self.userCanBeViewed = false
                }
                else {
                    let newValue = value as! Bool
                    self.userCanBeViewed = newValue
                }
                sender.locationDataDownloaded()
            })
        })
    }
    
    func shareMyLocation() {
        self.shareMyLocation(true)
    }
    
    func shareMyLocation(_ canShare: Bool) {
        FB.instance.setData(canShare, at: "shared_locations/\(self.otherId!)/\(self.userId!)/", completionHandler: nil, errorHandler: nil)
    }
    
    func getOtherLocation(_ sender: LocationProtocol) {
        FB.instance.getData("user_locations/\(self.otherId!)/", completionHandler: {
            value in
            if (value is NSNull) {
                
            }
            else {
                let dict = value as! Dictionary<String, Any>
                let latitude = dict["latitude"] as! Double
                let longitude = dict["longitude"] as! Double
                sender.locationCoordinatesDownloaded(lat: latitude, long: longitude)
            }
        })
    }
    
}
