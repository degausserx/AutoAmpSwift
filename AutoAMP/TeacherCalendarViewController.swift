//
//  TeacherCalendarViewController.swift
//  AutoAMP
//
//  Created by etudiant on 17/10/2017.
//  Copyright © 2017 etudiant. All rights reserved.
//

import UIKit

class TeacherCalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BookingListProtocol, TableCellClickProtocol {
    
    @IBOutlet weak var TableView: UITableView!
    
    let cell = "TeacherCalendarTableCell"
    
    var bookings: [Booking] = []
    var bookingDates: [Date] = []
    var bookingDatesSpread: [Date: Int] = [:]
    var groupedDates: [Date] = []
    var tempBookingsVar: [Booking] = []
    var bookingsByDate: [Date: [Booking]] = [Date: [Booking]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Schedule"
        
        self.TableView.dataSource = self
        self.TableView.delegate = self
        
        BookingList.instance.reload()
    }
    override func viewWillAppear(_ animated: Bool) {
        BookingList.instance.reloadForStudent(self, id: FB.instance.me)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.groupedDates.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let correctDate = self.groupedDates[section]
        return (self.bookingsByDate[correctDate]?.count)!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let thisDate = self.groupedDates[section]
        let dateFormatter = DateFormatter()
        let weekday = dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: thisDate) - 1]
        let formattedDate = DateTime(thisDate)
        let formattedDateResult = formattedDate.getDate()
        return "\(formattedDateResult) - \(weekday)"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cell, for: indexPath) as! TeacherCalendarTableViewCell
        let correctDate = self.groupedDates[indexPath.section]
        
        let bookingSection: [Booking] = self.bookingsByDate[correctDate]!
        let booking: Booking = bookingSection[indexPath.row]
        let dateObject = DateTime(booking.startDate)
        let timeString = dateObject.getTimeNoSeconds()
        
        cell.LabelOutletDate.text = "\(timeString)"
        cell.ButtonOutletLeft.backgroundColor = UIColor(hex: Colors.Purple)
        cell.ButtonOutletRight.backgroundColor = UIColor(hex: Colors.Red)
        if let student = UserList.instance.find(booking.studentId) {
            cell.ButtonOutletLeft.setTitle(student.firstName, for: .normal)
        }
        else {
            cell.ButtonOutletLeft.isHidden = true
            cell.ButtonOutletLeft.setTitle("No booking", for: .normal)
        }
        cell.ButtonOutletRight.setTitle("Delete", for: .normal)
        cell.ButtonOutletRight.isHidden = true
        cell.subDelegate = self
        cell.booking = booking
        return cell
    }
    
    func reloadTableDaily() {
        BookingList.instance.sort()
        self.bookings = BookingList.instance.bookings
        let datesArray = BookingList.instance.getCollections()
        self.bookingDates = datesArray.0
        self.bookingDatesSpread = datesArray.1
        self.groupedDates = self.bookingDatesSpread.keys.sorted(by: <)
        
        var myBookings: [Date: [Booking]] = [Date: [Booking]]()
        for date in self.groupedDates {
            let startDate = DateTime(date)
            let newStart = startDate.set(hour: 0).set(minute: 0).set(second: 0).getNumeric()
            let newEnd = startDate.set(hour: 23).set(minute: 55).set(second: 0).getNumeric()
            myBookings[date] = self.bookings.filter({ $0.startDate > newStart && $0.startDate <= newEnd }).sorted()
        }
        self.bookingsByDate = myBookings
        
        self.TableView.reloadData()
    }
    
    func setCurrentBookings(_ value: [Booking]) {
        //
    }
    
    func clickForAlert(_ alert: UIAlertController, animated: Bool) {
        present(alert, animated: true, completion: nil)
    }
    
    func tableMustRefresh() {
        self.reloadTableDaily()
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let cell = self.TableView.cellForRow(at: indexPath) as! TeacherCalendarTableViewCell
            let booking = cell.booking
            BookingList.instance.removeBooking(booking!, delegate: self)
        }
    }

}
