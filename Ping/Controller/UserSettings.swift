//
//  UserSettings.swift
//  Ping
//
//  Created by Ryan Soanes on 16/02/2019.
//  Copyright © 2019 LionStone. All rights reserved.
//

import UIKit
import Firebase

class UserSettings: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var settingsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTable.delegate = self //sets self as delegate for table view
        settingsTable.dataSource = self //sets self as data source for table view
        settingsTable.register(UINib(nibName: "UserSettingsCell", bundle: nil), forCellReuseIdentifier: "userSettingsCell") //register xib file to settings table view
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userSettingsCell", for: indexPath) as! UserSettingsCell //initiate custom cell for chat table view
        cell.settingsLabel.text = "Log out" //alter chatUsername element with test data for username
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            try Auth.auth().signOut()
            let controllerStack = self.navigationController?.viewControllers
            self.navigationController?.popToViewController((controllerStack?[0])!, animated: true)
        } catch let err {
            print(err)
        }
    }
}
