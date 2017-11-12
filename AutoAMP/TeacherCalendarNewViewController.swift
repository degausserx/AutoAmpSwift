//
//  TeacherCalendarNewViewController.swift
//  AutoAMP
//
//  Created by Admin on 20/10/2017.
//  Copyright © 2017 etudiant. All rights reserved.
//

import UIKit
import EPCalendarPicker
import ActionSheetPicker_3_0

class TeacherCalendarNewViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let cellDate: String = "TeacherCalendarDateCell"
    let cellTime: String = "TeacherCalendarTimeCell"
    
    var dates: [Date] = []
    var times: [Date] = []
    var lastTime: Date!
    var lastDuration:Int = 60
    
    @IBOutlet weak var TableOutlet: UITableView!
    @IBOutlet weak var ButtonOutletCancel: UIButton!
    @IBOutlet weak var ButtonOutletSave: UIButton!
    
    @IBAction func ActionAddDate(_ sender: UIButton) {
        self.addDates()
    }
    @IBAction func ActionAddTime(_ sender: UIButton) {
        self.addTimes(sender)
    }
    
    @IBAction func ActionCancel(_ sender: UIButton) {
        self.cancelAdd()
    }

    @IBAction func ActionSave(_ sender: UIButton) {
        self.save()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.TableOutlet.dataSource = self
        self.TableOutlet.delegate = self
        
        let dt = DateTime()
        self.lastTime = dt.set(minute: 0).set(second: 0).set(hour: 9).getNumeric()
        
        cleanInterface()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (section == 0) ? "Selected dates" : "Scheduled times"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? self.dates.count : self.times.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellDate, for: indexPath) as! TeacherCalendarAddDateTableViewCell
        if (indexPath.section == 0) {
            let theDate = DateTime(self.dates[indexPath.row])
            cell.OutletLabelLeft.text = theDate.getFull()
            cell.OutletLabelRight.text = theDate.getDate()
        }
        else {
            let theDate = DateTime(self.times[indexPath.row])
            cell.OutletLabelLeft.text = theDate.getTime()
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
                self.dates.remove(at: indexPath.row)
            }
            else {
                self.times.remove(at: indexPath.row)
            }
            self.TableOutlet.reloadData()
        }
    }

}

extension TeacherCalendarNewViewController: EPCalendarPickerDelegate {
    
    func cleanInterface() {
        self.ButtonOutletSave.backgroundColor = UIColor(hex: Colors.Green)
        self.ButtonOutletCancel.backgroundColor = UIColor(hex: Colors.Red)
    }
    
    func addDates() {
         let date = Date()
         let calendar = Calendar.current
         let year = calendar.component(.year, from: date)
         let maxYear = year + 1
         let calendarPicker = EPCalendarPicker(startYear: year, endYear: maxYear, multiSelection: true, selectedDates: nil)
         calendarPicker.weekdayTintColor = UIColor(hex: Colors.Black)
         calendarPicker.weekendTintColor = UIColor(hex: Colors.Black)
         calendarPicker.barTintColor = UIColor(hex: Colors.White)
         calendarPicker.monthTitleColor = UIColor(hex: Colors.Blue)
         calendarPicker.startDate = Date()
         calendarPicker.dateSelectionColor = UIColor(hex: Colors.Purple)
         calendarPicker.hightlightsToday = false
         calendarPicker.showsTodaysButton = false
         calendarPicker.calendarDelegate = self
         // calendarPicker
         let navigationController = UINavigationController(rootViewController: calendarPicker)
         self.present(navigationController, animated: true, completion: nil)
    }
    
    func addTimes(_ sender: UIButton) {
        let last = self.lastTime.addingTimeInterval(TimeInterval(self.lastDuration * 60))
        let datePicker = ActionSheetDatePicker(title: "DateAndTime:", datePickerMode: UIDatePickerMode.time, selectedDate: last, doneBlock: {
            picker, value, index in
            
            let date: Date = value as! Date
            let newDate = DateTime(date).set(second: 0).getNumeric()
            if (!self.times.contains(newDate)) {
                self.lastTime = newDate
                self.lastDuration = 60
                self.times.append(newDate)
                self.TableOutlet.reloadData()
            }
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender.superview!.superview)
        datePicker?.minuteInterval = 5
        
        datePicker?.show()
    }
    
    func save() {
        if (self.dates.count > 0 && self.times.count > 0) {
            let gregorian = Calendar(identifier: .gregorian)
            for date in self.dates {
                let newDate = date
                var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: newDate)
                for time in self.times {
                    components.hour = Calendar.current.component(.hour, from: time)
                    components.minute = Calendar.current.component(.minute, from: time)
                    components.second = 0
                    let finalDate = gregorian.date(from: components)!
                    let booking = Booking(date: finalDate, duration: 60)
                    BookingList.instance.add(booking)
                }
            }
            BookingList.instance.updateSafely(self)
        }
    }
    
    func returnTime(sender: UIDatePicker) {
        let date = sender.date
        if (!self.times.contains(date)) {
            self.times.append(date)
            self.TableOutlet.reloadData()
        }
    }
    
    func cancelAdd() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func epCalendarPicker(_: EPCalendarPicker, didSelectDate date: Date) {
        if (!self.dates.contains(date)) {
            self.dates.append(date)
            self.TableOutlet.reloadData()
        }
    }
    
    func epCalendarPicker(_: EPCalendarPicker, didSelectMultipleDate dates: [Date]) {
        let count = self.dates.count
        for date in dates {
            if (!self.dates.contains(date)) {
                self.dates.append(date)
            }
        }
        if (count < self.dates.count) {
            self.TableOutlet.reloadData()
        }
    }
    
    func epCalendarPicker(_: EPCalendarPicker, didCancel error: NSError) {
        
    }
    
}
