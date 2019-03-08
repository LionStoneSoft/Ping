//
//  ContactsView.swift
//  Ping
//
//  Created by Ryan Soanes on 08/03/2019.
//  Copyright © 2019 LionStone. All rights reserved.
//

import UIKit

class ContactsView: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var retrieveContactsTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        retrieveContactsTable.delegate = self //sets self as delegate for table view
        retrieveContactsTable.dataSource = self //sets self as data source for table view
        retrieveContactsTable.register(UINib(nibName: "ContactsUserCell", bundle: nil), forCellReuseIdentifier: "contactsUserCell") //register xib file to chat table view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactsUserCell", for: indexPath) as! ContactsUserCell //initiate custom cell for chat table view/dequeue for memory
        let username = ["Contact1", "Contact2", "Contact3"] //declared array for test data
        cell.contactUsername.text = username[indexPath.row] //alter contactUsername element with test data for username
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //returns number of cells wanted on tableview
        return 3
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
