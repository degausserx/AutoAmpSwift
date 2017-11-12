//
//  BookingList.swift
//  AutoAMP
//
//  Created by Admin on 20/10/2017.
//  Copyright © 2017 etudiant. All rights reserved.
//

import Foundation
import FirebaseAuth

class BookingList {
    
    static var instance: BookingList = BookingList()
    
    var bookings: [Booking] = []
    var studentBookings: [Booking] = []
    
    func getBookingsAt(_ date: Date) -> [Booking] {
        let startDate = DateTime(date)
        let endDate = DateTime(date)
        
        var newStart = startDate.set(hour: 0).set(minute: 0).set(second: 0).getNumeric()
        var newEnd = endDate.set(hour: 0).set(minute: 0).set(second: 0).getNumeric()
        newStart.addTimeInterval(TimeInterval(-1))
        newEnd.addTimeInterval(TimeInterval(60 * 60 * 24))
        return self.bookings.filter({ $0.startDate > newStart && $0.startDate < newEnd }).sorted()
    }
    
    private init() {
        
    }
    
    func reload() {
        self.reload(nil, date: Date())
    }
    
    func reloadForStudent(_ delegate: BookingListProtocol, id teacherId: String) {
        let userId = teacherId
        FB.instance.getData("learner_schedule_copy/\(FB.instance.me)/", completionHandler: {
            (data) in
            self.studentBookings = []
            if !(data is NSNull) {
                let newData = data as! Dictionary<String, Dictionary<String, AnyObject>>
                for (_, val) in newData {
                    self.setBookings(val, secondcopy: true)
                }
            }
            FB.instance.getData("users_schedule/\(userId)/", completionHandler: {
                (data) in
                self.bookings = []
                if !(data is NSNull) {
                    let newData = data as! Dictionary<String, Dictionary<String, AnyObject>>
                    for (_, val) in newData {
                        self.setBookings(val)
                    }
                    delegate.reloadTableDaily()
                }
            })
        })
    }
    
    func reload(_ delegate: BookingListProtocol?, date passDate: Date? = nil) {
        let userId = Auth.auth().currentUser!.uid
        FB.instance.getData("users_schedule/\(userId)/", completionHandler: {
            (data) in
            self.bookings = []
            if !(data is NSNull) {
                let newData = data as! Dictionary<String, Dictionary<String, AnyObject>>
                for (_, val) in newData {
                    self.setBookings(val)
                }
                if let del = delegate {
                    if let d = passDate {
                        let sendBookings = self.getBookingsAt(d)
                        del.setCurrentBookings(sendBookings)
                    }
                    del.reloadTableDaily()
                }
            }
        })
    }
    
    func reloadStudent(_ delegate: BookingListProtocol, id studentId: String) {
        FB.instance.getData("learner_schedule_copy/\(studentId)/", completionHandler: {
            (data) in
            self.bookings = []
            if !(data is NSNull) {
                let newData = data as! Dictionary<String, Dictionary<String, AnyObject>>
                for (_, val) in newData {
                    self.setBookings(val)
                }
                delegate.reloadTableDaily()
            }
        })
    }
    
    func getCollections() -> ([Date], [Date: Int]) {
        var tempDates: [Date] = []
        var tempDatesSpread: [Date: Int] = [:]
        for item in self.bookings {
            let theDate = DateTime(item.startDate)
            let newDate = theDate.set(second: 0).set(minute: 0).set(hour: 0).getNumeric()
            if !(tempDates.contains(newDate)) {
                tempDates += [newDate]
            }
            tempDatesSpread[newDate] = (tempDatesSpread[newDate] ?? 0) + 1
        }
        return (tempDates.sorted(by: >), tempDatesSpread)
    }
    
    func updateSafely(_ delegate: UIViewController?) {
        let userId = Auth.auth().currentUser!.uid
        FB.instance.getData("users_schedule/\(userId)/", completionHandler: {
            (data) in
            var oldBookings: [Booking] = []
            let dateTimeObject = DateTime()
            let minimumDate = dateTimeObject.set(second: 0).set(minute: 0).set(second: 0).getNumeric()
            if !(data is NSNull) {
                let newData = data as! Dictionary<String, Dictionary<String, AnyObject>>
                for (_, val) in newData {
                    oldBookings.append(self.newBooking(val))
                }
            }
            if self.bookings.isEmpty {
                self.bookings = oldBookings.filter({ $0.startDate > minimumDate })
            }
            else {
                var updatedBookings: [Booking] = []
                // 
                for booking in oldBookings {
                    if (self.bookings.contains(booking)) {
                        if (booking.studentId != "nil") {
                            updatedBookings.append(booking)
                        }
                    }
                    else {
                        updatedBookings.append(booking)
                    }
                }
                for booking in self.bookings {
                    if (!updatedBookings.contains(booking)) {
                        updatedBookings.append(booking)
                    }
                }
                updatedBookings = updatedBookings.filter({ $0.startDate > minimumDate })
                
                self.bookings = updatedBookings
                
                var keyValuePairs: [String: Any] = [:]
                
                for booking in updatedBookings {
                    
                    let data: [String : Any] = [
                        "teacherId": booking.teacherId,
                        "studentID": booking.studentId,
                        "classId": booking.classId,
                        "startDate": booking.startDateString,
                        "duration": booking.durationInMinutes,
                        "isBooked": booking.isBooked
                    ]
                    keyValuePairs.updateValue(data, forKey: "\(booking.classId)")
                }
                FB.instance.setData(keyValuePairs, at: "users_schedule/\(userId)/", completionHandler: {
                    (success, ref) in
                    if let del = delegate {
                        del.navigationController?.popViewController(animated: true)
                    }
                }, errorHandler: nil)
            }
        })
    }
    
    func updateSingle(_ booking: Booking) {
        self.updateSingle(booking, learner: "nil", delegate: nil)
    }
    func updateSingle(_ booking: Booking, learner: String) {
        self.updateSingle(booking, learner: learner, delegate: nil)
    }
    func updateSingle(_ booking: Booking, learner learnerId: String, delegate: BookingListProtocol? = nil) {
        if (self.studentBookings.contains(booking) && learnerId == FB.instance.me && booking.isBooked) {
            return
        }
        if (self.bookings.contains(booking) || learnerId == FB.instance.me) {
            let realLearnerId = (learnerId != "nil") ? learnerId : booking.studentId
            let userId = booking.teacherId
            FB.instance.updateData(booking.studentId, at: "users_schedule/\(userId)/\(booking.classId)/", key: "studentID", completionHandler: nil, errorHandler: nil)
            FB.instance.updateData(booking.isBooked, at: "users_schedule/\(userId)/\(booking.classId)/", key: "isBooked", completionHandler: {
                (error, ref) in
                if (booking.isBooked) {
                    let keyValuePair = self.getKeyValuePair(booking, learner: realLearnerId)
                    FB.instance.updateData(keyValuePair, at: "learner_schedule_copy/\(realLearnerId)/", key: "\(booking.classId)", completionHandler: {
                    (error, ref) in
                        self.studentBookings.append(booking)
                        if let del = delegate {
                            del.reloadTableDaily()
                        }
                    }, errorHandler: nil)
                }
                else {
                    FB.instance.delData(at: "learner_schedule_copy/\(realLearnerId)/\(booking.classId)/", completionHandler: {
                        (error, ref) in
                        if let indexOf = self.studentBookings.index(of: booking) {
                            self.studentBookings.remove(at: indexOf)
                        }
                        if let del = delegate {
                            del.reloadTableDaily()
                        }
                    })
                }
            }, errorHandler: nil)
        }
    }
    
    func add(_ value: Booking) {
        if (self.canAdd(value)) {
            self.bookings.append(value)
        }
    }
    
    private func canAdd(_ value: Booking) -> Bool {
        if let newTime = value.startDate {
            let newEndTime = value.endDate
            for booking in self.bookings {
                if let startTime = booking.startDate {
                    let endTime = booking.endDate
                    if (newTime == startTime) || (newTime > startTime && newTime < endTime) || (newTime < startTime && newEndTime > startTime) {
                        return false
                    }
                }
                else {
                    return false
                }
            }
            return true
        }
        return false
    }
    
    func remove(_ value: Booking) {
        if (self.bookings.contains(value)) {
            self.bookings.remove(at: self.bookings.index(of: value)!)
        }
    }
    
    func sort() {
        self.bookings = self.bookings.sorted()
    }
    
    func newBooking(_ value: [String: Any]) -> Booking {
        let teacherId = value["teacherId"] as! String
        let classId = value["classId"] as! String
        let studentId = value["studentID"] as! String
        let startDate = value["startDate"] as! String
        let isBooked = value["isBooked"] as! Bool
        let duration = value["duration"] as! Int
        let dt = DateTime()
        let startDateDate = dt.setFromString(startDate).getNumeric()
        
        let booking = Booking(date: startDateDate, duration: duration)
        booking.classId = classId
        booking.studentId = studentId
        booking.isBooked = isBooked
        booking.teacherId = teacherId
        
        return booking
    }
    
    func setBookings(_ value: [String: Any]) {
        self.setBookings(value, secondcopy: false)
    }
    func setBookings(_ value: [String: Any], secondcopy: Bool) {
        let booking = newBooking(value)
        let dateTimeObject = DateTime()
        let minimumDate = dateTimeObject.set(second: 0).set(minute: 0).set(second: 0).getNumeric()
        if (!secondcopy && !bookings.contains(booking) && booking.startDate > minimumDate) {
            self.bookings.append(booking)
        }
        if (secondcopy && !studentBookings.contains(booking) && booking.startDate > minimumDate) {
            self.studentBookings.append(booking)
        }
    }
    
    func getKeyValuePair(_ booking: Booking, learner learnerId: String) -> [String: Any] {
        
        let data: [String : Any] = [
            "teacherId": booking.teacherId,
            "studentID": booking.studentId,
            "classId": booking.classId,
            "startDate": booking.startDateString,
            "duration": booking.durationInMinutes,
            "isBooked": booking.isBooked
        ]
        
        return data
    }
    
    func removeBooking(_ booking: Booking, delegate: TableCellClickProtocol?) {
        FB.instance.delData(at: "users_schedule/\(FB.instance.me)/\(booking.classId)/", completionHandler: {
            (error, ref) in
            if (booking.studentId != "nil") {
                FB.instance.delData(at: "learner_schedule_copy/\(booking.studentId)/\(booking.classId)/", completionHandler: {
                    (error, ref) in
                    self.bookings.remove(at: self.bookings.index(of: booking)!)
                    if let del = delegate {
                        del.tableMustRefresh()
                    }
                })
            }
            else {
                self.bookings.remove(at: self.bookings.index(of: booking)!)
                if let del = delegate {
                    del.tableMustRefresh()
                }
            }
        })
    }
    
}
