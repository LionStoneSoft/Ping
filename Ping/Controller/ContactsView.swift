//
//  ContactsView.swift
//  Ping
//
//  Created by Ryan Soanes on 08/03/2019.
//  Copyright © 2019 LionStone. All rights reserved.
//

import UIKit
import Firebase

protocol ViewControllerBDelegate: class {
    func getDataBack(selectedUser: UserStored) -> ()
}

class ContactsView: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var users = [UserStored]()
    weak var delegate: ViewControllerBDelegate?
    
    @IBOutlet var retrieveContactsTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        retrieveContactsTable.delegate = self //sets self as delegate for table view
        retrieveContactsTable.dataSource = self //sets self as data source for table view
        retrieveContactsTable.register(UINib(nibName: "ContactsUserCell", bundle: nil), forCellReuseIdentifier: "contactsUserCell") //register xib file to chat table view
        retrieveUser()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //returns number of cells wanted on tableview
        return users.count
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        //self.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    func retrieveUser() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            if let userDictionary = snapshot.value as? [String: AnyObject] {
                let user = UserStored()
                user.setValuesForKeys(userDictionary)
                //print(user.username, user.email)
                self.users.append(user)
                DispatchQueue.main.async {
                    self.retrieveContactsTable.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactsUserCell", for: indexPath) as! ContactsUserCell //initiate custom cell for chat table view/dequeue for memory
        let user = users[indexPath.row]
        cell.contactUsername.text = user.username //alter contactUsername cell element with data for username
        if let profileImageUrl = user.profileImageURL {
            cell.contactImage.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            print("dismissed view")
            self.delegate?.getDataBack(selectedUser: self.users[indexPath.row])

        }
    }
}

