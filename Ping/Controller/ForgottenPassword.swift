//
//  ForgottenPassword.swift
//  Ping
//
//  Created by Ryan Soanes on 11/02/2019.
//  Copyright © 2019 LionStone. All rights reserved.
//

import UIKit
import Firebase

class ForgottenPassword: UIViewController {
    
    @IBOutlet var emailField: UITextField!
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButton(_ sender: UIButton) {
        Auth.auth().sendPasswordReset(withEmail: emailField.text!) { (error) in
            if error != nil {
                guard let error = AuthErrorCode(rawValue: (error?._code)!) else {
                    return
                }
                self.authErrorHandling(code: error) //pass error code to authErrorHandling switch function
            } else {
                print("Reset Password Success")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func authErrorHandling(code: AuthErrorCode) {
        switch code {
        case .invalidEmail:
            errorLabel.text = "Invalid Email"
        case .networkError:
            errorLabel.text = "Network error occured"
        default:
            errorLabel.text = "An error occured"
        }
    }
}
