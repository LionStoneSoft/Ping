//
//  UserSettings.swift
//  Ping
//
//  Created by Ryan Soanes on 16/02/2019.
//  Copyright © 2019 LionStone. All rights reserved.
//

import UIKit

class UserSettings: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
