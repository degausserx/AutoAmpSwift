//
//  CreateAccountViewController.swift
//  AutoAMP
//
//  Created by etudiant on 16/10/2017.
//  Copyright © 2017 etudiant. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class CreateAccountViewController: UIViewController {
    
    var AccountType: String!

    @IBOutlet weak var OutletLabelType: UILabel!
    @IBOutlet weak var OutletButtonCancel: UIButton!
    @IBOutlet weak var OutletButtonSave: UIButton!
    
    @IBOutlet weak var OutletTextFirstName: UITextField!
    @IBOutlet weak var OutletTextLastName: UITextField!
    @IBOutlet weak var OutletTextEmail: UITextField!
    @IBOutlet weak var OutletTextPasswordConfirm: UITextField!
    @IBOutlet weak var OutletTextPassword: UITextField!
    @IBOutlet weak var OutletScrollBar: UIScrollView!
    
    @IBAction func ActionButtonSave(_ sender: UIButton) {
        self.attemptCreate()
    }
    @IBAction func ActionButtonCancel(_ sender: UIButton) {
        self.clearFields()
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OutletLabelType.text = self.AccountType
        let bg = (self.AccountType == "Teacher") ? UIColor(hex: Colors.Orange) : UIColor(hex: Colors.Purple)
        self.view.backgroundColor = bg
        self.OutletScrollBar.backgroundColor = bg
        
        OutletButtonSave.backgroundColor = UIColor(hex: Colors.Green)
        OutletButtonCancel.backgroundColor = UIColor(hex: Colors.Red)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func clearFields() {
        self.OutletTextEmail.text = ""
        self.OutletTextPassword.text = ""
        self.OutletTextPasswordConfirm.text = ""
        self.OutletTextLastName.text = ""
        self.OutletTextFirstName.text = ""
    }
    
    private func attemptCreate() {
        let isTeacher = (self.AccountType == "Teacher") ? true : false
        if let first = self.OutletTextFirstName.text, let last = self.OutletTextLastName.text, let email = self.OutletTextEmail.text, let password = self.OutletTextPassword.text, let confirm = self.OutletTextPasswordConfirm.text {
            // validate names
            if (first.characters.count < 1 || last.characters.count < 1 || email.characters.count < 1 || password.characters.count < 1) {
                self.showAlert("Error creating account", message: "All fields are required", button: "OK")
            } else if (password != confirm) {
                self.showAlert("Error creating account", message: "Passwords don't match", button: "OK")
            } else {
                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    if let _ = user?.email {
                        let userId = user!.uid
                        FB.instance.setData(first, at: "users/\(userId)/general/firstName/", completionHandler: {
                            (success, dbref) in
                            FB.instance.setData(last, at: "users/\(userId)/general/lastName/", completionHandler: {
                                (success, dbref) in
                                FB.instance.setData(isTeacher, at: "users/\(userId)/general/isTeacher/", completionHandler: {
                                    (success, dbref) in
                                    FB.instance.setData(DateTime().getDateTime(), at: "users/\(userId)/general/lastOnline/", completionHandler: {
                                        (success, dbref) in
                                        self.clearFields()
                                        self.dismiss(animated: true, completion: nil)
                                    }, errorHandler: nil)
                                }, errorHandler: nil)
                            }, errorHandler: nil)
                        }, errorHandler: nil)
                        
                    }
                    
                    else {
                        self.showAlert("Error creating user", message: error!.localizedDescription, button: "OK")
                    }
                }
            }
        } else {
            self.showAlert("Error creating account", message: "All fields are required", button: "OK")
        }
        
    }
    
    func showAlert(_ title: String, message: String, button: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: button, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
