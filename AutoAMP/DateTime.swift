//
//  DateTime.swift
//  AutoAMP
//
//  Created by etudiant on 17/10/2017.
//  Copyright © 2017 etudiant. All rights reserved.
//

import Foundation

class DateTime {
    
    let calendar = Calendar(identifier: .gregorian)
    var new: Date!
    
    convenience init() {
        self.init(Date())
    }
    
    init(_ with: Date) {
        self.new = with
    }
    
    func setFromString(_ value: String) -> DateTime {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let s = dateFormatter.date(from: value)
        self.new = s
        return self
    }
    
    func getFull() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM dd"
        return dateFormatter.string(from: self.new)
    }
    
    func getNumeric() -> Date {
        return self.new
    }
    
    func getDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self.new)
    }
    
    func getTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss"
        return formatter.string(from: self.new)
    }
    
    func getTimeNoSeconds() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        return formatter.string(from: self.new)
    }
    
    func getDateTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self.new)
    }
    
    func setFromSpinner(_ value: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
        let s = dateFormatter.date(from: value)
        self.new = s
    }
    
    func set(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) -> DateTime {
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: new)
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        self.new = calendar.date(from: components)!
        return self
    }
    
    func set(year: Int) -> DateTime {
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: new)
        components.year = year
        self.new = calendar.date(from: components)!
        return self
    }
    
    func set(month: Int) -> DateTime {
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: new)
        components.month = month
        self.new = calendar.date(from: components)!
        return self
    }
    
    func set(day: Int) -> DateTime {
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: new)
        components.day = day
        self.new = calendar.date(from: components)!
        return self
    }
    
    func set(hour: Int) -> DateTime {
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: new)
        components.hour = hour
        self.new = calendar.date(from: components)!
        return self
    }
    
    func set(minute: Int) -> DateTime {
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: new)
        components.minute = minute
        self.new = calendar.date(from: components)!
        return self
    }
    
    func set(second: Int) -> DateTime {
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: new)
        components.second = second
        self.new = calendar.date(from: components)!
        return self
    }
}
