//
//  BookingListProtocol.swift
//  AutoAMP
//
//  Created by Admin on 21/10/2017.
//  Copyright © 2017 etudiant. All rights reserved.
//

import Foundation

protocol BookingListProtocol {
    func setCurrentBookings(_ value: [Booking])
    func reloadTableDaily()
}
