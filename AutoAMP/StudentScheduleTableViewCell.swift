//
//  StudentScheduleTableViewCell.swift
//  AutoAMP
//
//  Created by Admin on 22/10/2017.
//  Copyright © 2017 etudiant. All rights reserved.
//

import UIKit

class StudentScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var OutletLabelLeft: UILabel!
    @IBOutlet weak var OutletButtonBook: UIButton!
    var booking: Booking!
    var subDelegate: TableCellClickProtocol!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func ActionBook(_ sender: UIButton) {
        let removing = self.booking.isBooked
        alertConfirm(removing: removing)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func alertConfirm() {
        self.alertConfirm(removing: false)
    }
    
    func alertConfirm(removing: Bool) {
        if (self.booking.isBooked && booking.studentId != FB.instance.me) || OutletButtonBook.currentTitle == "n/a" {
            return
        }
        let dateObject = DateTime(self.booking.startDate)
        let alertTitle = (removing) ? "Remove date" : "Book date"
        let refreshAlert = UIAlertController(title: alertTitle, message: "Scheduled at: \(dateObject.getDateTime())", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.modifyCell()
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.subDelegate.clickForAlert(refreshAlert, animated: true)
    }
    
    func modifyCell() {
        let bookingIndex = BookingList.instance.bookings.index(of: self.booking)
        if (!self.booking.isBooked) {
            self.booking.studentId = FB.instance.me
            self.booking.isBooked = true
        }
        else {
            self.booking.studentId = ""
            self.booking.isBooked = false
        }
        BookingList.instance.bookings[bookingIndex!] = self.booking
        BookingList.instance.updateSingle(self.booking, learner: FB.instance.me, delegate: self.subDelegate as? BookingListProtocol)
    }

}
