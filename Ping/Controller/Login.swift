//
//  ViewController.swift
//  Ping
//
//  Created by Ryan Soanes on 21/01/2019.
//  Copyright © 2019 LionStone. All rights reserved.
//

import UIKit
import Firebase

class Login: UIViewController {

    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }

    @IBAction func signInPressed(_ sender: UIButton) {
        Auth.auth().currentUser?.reload(completion: nil)
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
            if error != nil {
                print(error!)
            } else {
                print("Login Success")
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        }
    }
    
    override open var shouldAutorotate: Bool { //disable auto rotate for this view
        return false
    }
    
}

//hides keyboard when screen is tapped
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
