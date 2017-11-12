//
//  LoginScreenViewController.swift
//  AutoAMP
//
//  Created by etudiant on 10/10/2017.
//  Copyright © 2017 etudiant. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginScreenViewController: UIViewController {
    
    var appDelegate: AppDelegate!
    
    @IBOutlet weak var OutletUsername: UITextField!
    @IBOutlet weak var OutletPassword: UITextField!
    @IBOutlet weak var OutletButtonLogin: UIButton!
    @IBOutlet weak var OutletButtonTeacher: UIButton!
    @IBOutlet weak var OutletButtonLearner: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OutletButtonLogin.backgroundColor = UIColor(hex: Colors.Green)
        OutletButtonLearner.backgroundColor = UIColor(hex: Colors.Purple)
        OutletButtonTeacher.backgroundColor = UIColor(hex: Colors.Orange)
        
        OutletUsername.placeholder = "Email address"
        OutletPassword.placeholder = "Password"
        
        if let user = Auth.auth().currentUser {
            let userEmail = user.email
            let userId = user.uid
            FB.instance.getData("users/\(userId)/general/isTeacher/", completionHandler: {
            (value) in
                if !(value is NSNull) {
                    if let isTeacher = value as! Bool? {
                        let seague = (isTeacher) ? "TeacherLoginSuccess" : "StudentLoginSuccess"
                        self.OutletPassword.text = ""
                        self.OutletUsername.text = userEmail
                        self.performSegue(withIdentifier: seague, sender: nil)
                    }
                }
                else {
                    do {
                        try Auth.auth().signOut()
                    } catch {
                        
                    }
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func ActionCreateTeacher(_ sender: UIButton) {
        performSegue(withIdentifier: "CreateAccount", sender: "Teacher")
    }
    
    @IBAction func ActionCreateLearner(_ sender: UIButton) {
        performSegue(withIdentifier: "CreateAccount", sender: "Learner")
    }
    
    @IBAction func ActionLogin(_ sender: UIButton) {
        if let email = OutletUsername.text, let password = OutletPassword.text {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if let userId = user?.uid {
                    FB.instance.getData("users/\(userId)/general/isTeacher/", completionHandler: {
                        (value) in
                        if let value: Bool = value as? Bool {
                            let seague = (value) ? "TeacherLoginSuccess" : "StudentLoginSuccess"
                            self.OutletPassword.text = ""
                            self.performSegue(withIdentifier: seague, sender: nil)
                        }
                        else {
                            self.showAlert("Error signing in", message: "Problem with account permissions", button: "OK")
                        }
                    })
                }
                else {
                    self.showAlert("Error signing in", message: error!.localizedDescription, button: "OK")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "CreateAccount") {
            if let destinationViewController = segue.destination as? CreateAccountViewController {
                if let definition = sender as? String {
                    destinationViewController.AccountType = definition
                }
            }
        }
    }
    
    func showAlert(_ title: String, message: String, button: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: button, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
