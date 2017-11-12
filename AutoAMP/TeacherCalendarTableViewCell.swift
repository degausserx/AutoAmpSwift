//
//  TeacherCalendarTableViewCell.swift
//  AutoAMP
//
//  Created by etudiant on 18/10/2017.
//  Copyright © 2017 etudiant. All rights reserved.
//

import UIKit

class TeacherCalendarTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var booking: Booking!
    var subDelegate: TableCellClickProtocol!
    
    @IBOutlet weak var LabelOutletDate: UILabel!
    @IBOutlet weak var ButtonOutletRight: UIButton!
    @IBOutlet weak var ButtonOutletLeft: UIButton!
    @IBAction func ButtonActionRight(_ sender: UIButton) {
    }
    @IBAction func ButtonActionLeft(_ sender: UIButton) {
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
