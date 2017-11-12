//
//  Booking.swift
//  AutoAMP
//
//  Created by Admin on 20/10/2017.
//  Copyright © 2017 etudiant. All rights reserved.
//

import Foundation
import FirebaseAuth

class Booking: Equatable, Comparable {
    
    var teacherId: String = ""
    var studentId: String = "nil"
    var classId: String = ""
    var startDate: Date!
    var endDate: Date {
        return self.startDate.addingTimeInterval(TimeInterval(self.durationInMinutes * 60))
    }
    var durationInMinutes: Int = 60
    var isBooked: Bool = false
    var startDateString: String {
        return DateTime(self.startDate).getDateTime()
    }
    
    init(date: Date, duration: Int) {
        self.teacherId = (Auth.auth().currentUser?.uid)!
        self.startDate = date
        self.durationInMinutes = duration
        self.classId = Random.randomString(length: 20)
    }

    static func ==(lhs: Booking, rhs: Booking) -> Bool {
        return conflictsWith(lhs: lhs, rhs: rhs)
    }
    
    static func <(lhs: Booking, rhs: Booking) -> Bool {
        return (lhs.startDate < rhs.startDate) ? true : false
    }
    
    static func conflictsWith(lhs: Booking, rhs: Booking) -> Bool {
        if let l = lhs.startDate, let r = rhs.startDate {
            if (l == r) {
                return true
            }
            let duration = (l < r) ? lhs.durationInMinutes : rhs.durationInMinutes
            let firstDate = (l < r) ? l : r
            let lastDate = (l > r) ? l : r
            let virtualDate = firstDate.addingTimeInterval(TimeInterval(duration * 60))
            return (virtualDate > lastDate) ? true : false
        }
        return false
    }
    
    var name: String {
        return DateTime(self.startDate).getDateTime()
    }
    
}
