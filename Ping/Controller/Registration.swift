//
//  Registration.swift
//  Ping
//
//  Created by Ryan Soanes on 11/02/2019.
//  Copyright © 2019 LionStone. All rights reserved.
//

import UIKit
import Firebase

class Registration: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        hideKeyboardWhenTappedAround()
    }
    

    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func uploadPhotoButton(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
        
        
    }
    
    @IBAction func registerButtonPress(_ sender: UIButton) {
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
            if error != nil {
                print(error!)
            } else {
                let uid = Auth.auth().currentUser!.uid
                let ref = Database.database().reference().child("users").child(uid)
                let values = ["username": self.usernameField.text!, "email": self.emailField.text!] as [String : Any]
                ref.updateChildValues(values, withCompletionBlock: { (err, ref) in
                    if err != nil {
                        print(err!)
                        return
                    }
                })
                print("Registration Success")
                self.performSegue(withIdentifier: "goToLoginAfterRegister", sender: self)
            }
        }
    }
}
