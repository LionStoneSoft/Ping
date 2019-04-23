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
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }

    @IBAction func signInPressed(_ sender: UIButton) {
        Auth.auth().currentUser?.reload(completion: nil) //reloads state of current user
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in //Uses Firebase Auth method for sign-in
            if error != nil {
                guard let error = AuthErrorCode(rawValue: (error?._code)!) else {
                    return
                }
                self.authErrorHandling(code: error) //pass error code to authErrorHandling switch function
            } else {
                print("Login Success")
                self.errorLabel.text = ""
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        }
    }
    
    func authErrorHandling(code: AuthErrorCode) {
        switch code {
        case .wrongPassword:
            errorLabel.text = "Password Incorrect"
        case .emailAlreadyInUse:
            errorLabel.text = "Email already in use"
        case .userNotFound:
            errorLabel.text = "Invalid Email"
        case .networkError:
            errorLabel.text = "Network error occured"
        default:
            errorLabel.text = "An error occured"
        }
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
