//
//  TeacherUpcomingViewController.swift
//  AutoAMP
//
//  Created by etudiant on 18/10/2017.
//  Copyright © 2017 etudiant. All rights reserved.
//

import UIKit
import EPCalendarPicker

class TeacherUpcomingViewController: UIViewController, EPCalendarPickerDelegate, UITableViewDelegate, UITableViewDataSource, BookingListProtocol {
    

    @IBOutlet weak var OutletTable: UITableView!
    
    var cell1: String = "TeacherUpcomingCell1"
    var currentDate: Date = Date()
    var currentDaily: [Booking] = []
    
    @IBAction func CalendarAction(_ sender: Any) {
        
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date) - 1
        let maxYear = year + 2
        let calendarPicker = EPCalendarPicker(startYear: year, endYear: maxYear, multiSelection: false, selectedDates: [self.currentDate])
        calendarPicker.weekdayTintColor = UIColor(hex: Colors.Black)
        calendarPicker.weekendTintColor = UIColor(hex: Colors.Black)
        calendarPicker.barTintColor = UIColor(hex: Colors.White)
        calendarPicker.monthTitleColor = UIColor(hex: Colors.Blue)
        calendarPicker.startDate = Date()
        calendarPicker.dateSelectionColor = UIColor(hex: Colors.Purple)
        calendarPicker.hightlightsToday = false
        calendarPicker.showsTodaysButton = true
        calendarPicker.calendarDelegate = self
        // calendarPicker
        let navigationController = UINavigationController(rootViewController: calendarPicker)
        self.present(navigationController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Upcoming"
        
        self.OutletTable.dataSource = self
        self.OutletTable.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.currentDaily = BookingList.instance.getBookingsAt(self.currentDate)
        BookingList.instance.reload(self, date: self.currentDate)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func epCalendarPicker(_: EPCalendarPicker, didCancel error: NSError) {
        
    }
    
    func epCalendarPicker(_: EPCalendarPicker, didSelectDate date: Date) {
        self.currentDate = date
        self.currentDaily = BookingList.instance.getBookingsAt(date)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.currentDaily = BookingList.instance.getBookingsAt(self.currentDate)
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dt = DateTime(self.currentDate)
        return dt.getDate()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentDaily.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cell1, for: indexPath) as! TeacherUpcomingTableViewCell
        let someTime = self.currentDaily[indexPath.row]
        cell.OutletLabelLeft.text = "\(DateTime(someTime.startDate).getTimeNoSeconds())-\(DateTime(someTime.endDate).getTimeNoSeconds())"
        if let userObject = UserList.instance.find(someTime.studentId) {
            cell.OutletLabelRight.text = (someTime.studentId == "nil") ? "" : "\(userObject.firstName) \(userObject.lastName)"
        }
        else {
            cell.OutletLabelRight.text = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            if (indexPath.section == 0) {
                let formerStudentId = self.currentDaily[indexPath.row].studentId
                self.currentDaily[indexPath.row].isBooked = false
                self.currentDaily[indexPath.row].studentId = "nil"
                BookingList.instance.bookings = self.currentDaily
                BookingList.instance.updateSingle(self.currentDaily[indexPath.row], learner: formerStudentId)
                self.OutletTable.reloadData()
            }
        }
    }
    
    func reloadTableDaily() {
        self.OutletTable.reloadData()
    }
    
    func setCurrentBookings(_ value: [Booking]) {
        self.currentDaily = value
    }
}
