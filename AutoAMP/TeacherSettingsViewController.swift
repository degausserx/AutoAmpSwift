//
//  TeacherSettingsViewController.swift
//  AutoAMP
//
//  Created by Admin on 16/10/2017.
//  Copyright © 2017 etudiant. All rights reserved.
//

import UIKit
import FirebaseAuth
import PhoneNumberKit

class TeacherSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UserListProtocol {
    
    let cellId: String = "TeacherSettingsCell1"
    let cellId2: String = "TeacherSettingsCell2"
    
    @IBOutlet weak var SettingsTable: TeacherSettingsTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"

        UserList.instance.update(self)
        
        self.SettingsTable.delegate = self
        self.SettingsTable.dataSource = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (section == 0) ? "Personal" : "Connection"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? 3 : 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell: TeacherSettingsTableViewCell2
            cell = tableView.dequeueReusableCell(withIdentifier: self.cellId2, for: indexPath) as! TeacherSettingsTableViewCell2
            cell.OutletLabelLeft.text = Text.Settings.TeacherHeaders[indexPath.row + 1]
            if let myClass = UserList.instance.me {
                switch indexPath.row {
                case 0:
                    cell.OutletLabelRight.text = myClass.firstName
                case 1:
                    cell.OutletLabelRight.text = myClass.lastName
                case 2:
                    cell.OutletLabelRight.text = myClass.phone
                default:
                    cell.OutletLabelRight.text = ""
                }
            } else {
                cell.OutletLabelRight.text = ""
            }
            cell.selectionStyle = .blue
            return cell
        } else {
            let cell: TeacherSettingsTableViewCell
            cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! TeacherSettingsTableViewCell
            cell.accessoryType = .disclosureIndicator
            cell.OutletLabel.text = Text.Settings.TeacherHeaders[0]
            cell.selectionStyle = .blue
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            self.changeName(first: true)
        case (0, 1):
            self.changeName(first: false)
        case (0, 2):
            self.changeNumber()
        case (1, 0):
            self.logout()
        default:
            print("")
        }
    }
    
    func logout() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            UserList.instance.data = []
            BookingList.instance.bookings = []
            dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func changeNumber() {
        let alert = UIAlertController(title: "Phone number", message: "Modify your number?", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { (action: UIAlertAction!) in
            let textField = alert.textFields![0] as UITextField
            if let text = textField.text {
                let newNumber = self.validatePhone(text)
                if (newNumber.characters.count) > 0 {
                    self.updateString(newNumber, key: "phone", row: 2)
                }
            }
        })
        
        alert.addTextField { (textField: UITextField!) in textField.keyboardType = UIKeyboardType.phonePad }
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func changeName(first: Bool = true) {
        let namePlace = (first) ? "first" : "last"
        let row = (first) ? 0 : 1
        let alert = UIAlertController(title: "\(namePlace.localizedUppercase) name", message: "Modify your name?", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { (action: UIAlertAction!) in
            let textField = alert.textFields![0] as UITextField
            if let text = textField.text {
                if (text.characters.count) > 0 {
                    self.updateString(text, key: "\(namePlace)Name", row: row)
                }
            }
        })
        
        alert.addTextField { (textField: UITextField!) in textField.keyboardType = UIKeyboardType.alphabet }
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateString(_ value: String, key: String, row: Int) {
        let userId = Auth.auth().currentUser!.uid
        FB.instance.setData(value, at: "users/\(userId)/general/\(key)/", completionHandler: {
        (error, ref) in
            let index = IndexPath(row: row, section: 0)
            let cell = self.SettingsTable.cellForRow(at: index) as! TeacherSettingsTableViewCell2
            cell.OutletLabelRight.text = value
        }, errorHandler: nil)
    }
    
    func validatePhone(_ value: String) -> String {
        let phoneNumberKit = PhoneNumberKit()
        
        do {
            let phoneNumber = try phoneNumberKit.parse(value, withRegion: "BE")
            let newNumber = phoneNumberKit.format(phoneNumber, toType: .international)
            return newNumber
        } catch {
            return ""
        }
        
    }
    
    func userListRefresh() {
        self.SettingsTable.reloadData()
    }

}
