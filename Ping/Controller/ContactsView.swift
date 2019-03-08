//
//  ContactsView.swift
//  Ping
//
//  Created by Ryan Soanes on 08/03/2019.
//  Copyright © 2019 LionStone. All rights reserved.
//

import UIKit

class ContactsView: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
