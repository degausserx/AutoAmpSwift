//
//  StudentUpcomingViewController.swift
//  AutoAMP
//
//  Created by Admin on 22/10/2017.
//  Copyright © 2017 etudiant. All rights reserved.
//

import UIKit

class StudentUpcomingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TableCellClickProtocol, BookingListProtocol {
    
    let cell = "StudentUpcomingTableCell"

    @IBOutlet weak var OutletTable: UITableView!
    
    var bookings: [Booking] = []
    var bookingDates: [Date] = []
    var bookingDatesSpread: [Date: Int] = [:]
    var groupedDates: [Date] = []
    var tempBookingsVar: [Booking] = []
    var bookingsByDate: [Date: [Booking]] = [Date: [Booking]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Bookings"
        
        self.OutletTable.delegate = self
        self.OutletTable.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        BookingList.instance.reloadStudent(self, id: FB.instance.me)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.groupedDates.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let thisDate = self.groupedDates[section]
        let dateFormatter = DateFormatter()
        let weekday = dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: thisDate) - 1]
        let formattedDate = DateTime(thisDate)
        let formattedDateResult = formattedDate.getDate()
        return "\(formattedDateResult) - \(weekday)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let correctDate = self.groupedDates[section]
        return (self.bookingsByDate[correctDate]?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.OutletTable.dequeueReusableCell(withIdentifier: self.cell, for: indexPath) as! StudentUpcomingTableViewCell
        
        let correctDate = self.groupedDates[indexPath.section]
        
        let bookingSection: [Booking] = self.bookingsByDate[correctDate]!
        let booking: Booking = bookingSection[indexPath.row]
        let dateObject = DateTime(booking.startDate)
        let timeString = dateObject.getTimeNoSeconds()
        
        cell.OutletLabelLeft.text = "\(timeString)"
        cell.OutletButton1.backgroundColor = UIColor(hex: Colors.Purple)
        cell.OutletButton2.backgroundColor = UIColor(hex: Colors.Red)
        if let teacher = UserList.instance.find(booking.teacherId) {
            cell.OutletButton1.setTitle(teacher.firstName, for: .normal)
        }
        cell.subDelegate = self
        cell.booking = booking
        return cell
    }
    
    func clickForAlert(_ alert: UIAlertController, animated: Bool) {
        present(alert, animated: true, completion: nil)
    }
    
    func tableMustRefresh() {
        self.OutletTable.reloadData()
    }
    
    func setCurrentBookings(_ value: [Booking]) {
        
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
        
        self.OutletTable.reloadData()
    }
    
    func selectTabIndex(_ index: Int, teacher: User) {
        // figure out a way to swap tabs and load info automatically
    }

}
