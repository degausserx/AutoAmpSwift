//
//  TableCellClickProtocol.swift
//  AutoAMP
//
//  Created by Admin on 22/10/2017.
//  Copyright © 2017 etudiant. All rights reserved.
//

import Foundation
import UIKit

protocol TableCellClickProtocol {
    func clickForAlert(_ alert: UIAlertController, animated: Bool)
    func tableMustRefresh()
}
