//
//  StudentUpcomingTableViewCell.swift
//  AutoAMP
//
//  Created by Admin on 22/10/2017.
//  Copyright © 2017 etudiant. All rights reserved.
//

import UIKit

class StudentUpcomingTableViewCell: UITableViewCell {

    @IBOutlet weak var OutletLabelLeft: UILabel!
    @IBOutlet weak var OutletButton1: UIButton!
    @IBOutlet weak var OutletButton2: UIButton!
    
    var booking: Booking!
    var subDelegate: TableCellClickProtocol!
    
    @IBAction func ActionButton1(_ sender: UIButton) {
        if let user = UserList.instance.find(booking.teacherId) {
            let delegate = subDelegate as! StudentUpcomingViewController
            delegate.selectTabIndex(2, teacher: user)
        }
    }
    
    @IBAction func ActionButton2(_ sender: UIButton) {
        self.alertConfirmRemove()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func alertConfirmRemove() {
        let dateObject = DateTime(self.booking.startDate)
        let alertTitle = "Remove booking"
        let refreshAlert = UIAlertController(title: alertTitle, message: "Scheduled at: \(dateObject.getDateTime())", preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.modifyCell()
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.subDelegate.clickForAlert(refreshAlert, animated: true)
    }
    
    func modifyCell() {
        let bookingIndex = BookingList.instance.bookings.index(of: self.booking)
        self.booking.studentId = "nil"
        self.booking.isBooked = false
        BookingList.instance.bookings.remove(at: bookingIndex!)
        BookingList.instance.updateSingle(self.booking, learner: FB.instance.me, delegate: subDelegate as? BookingListProtocol)
    }

}
