//
//  LocationProtocol.swift
//  AutoAMP
//
//  Created by etudiant on 23/10/2017.
//  Copyright © 2017 etudiant. All rights reserved.
//

import Foundation

protocol LocationProtocol {
    func locationDataDownloaded()
    func locationCoordinatesDownloaded(lat: Double, long: Double)
}
