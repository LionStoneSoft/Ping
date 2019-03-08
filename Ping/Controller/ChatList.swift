//
//  ChatList.swift
//  Ping
//
//  Created by Ryan Soanes on 11/02/2019.
//  Copyright © 2019 LionStone. All rights reserved.
//

import UIKit
import Firebase

class ChatList: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var chatsTableView: UITableView!
    @IBOutlet var topNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        chatsTableView.delegate = self //sets self as delegate for table view
        chatsTableView.dataSource = self //sets self as data source for table view
        chatsTableView.register(UINib(nibName: "CustomChatCell", bundle: nil), forCellReuseIdentifier: "customChatCell") //register xib file to chat table view
        retrieveUsername()
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customChatCell", for: indexPath) as! CustomChatCell //initiate custom cell for chat table view
        let username = ["Username1", "Username2", "Username3"] //declared array for test data
        cell.chatUsername.text = username[indexPath.row] //alter chatUsername element with test data for username
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //returns number of cells wanted on tableview
        return 3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toMessages", sender: self)
    }
    
    @IBAction func addConvo(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToContacts", sender: self)
    }
    
    func retrieveUsername() {
        let currentUser = Auth.auth().currentUser
        var databaseReference: DatabaseReference!
        databaseReference = Database.database().reference()
        databaseReference.child("users").child((currentUser?.uid)!).observeSingleEvent(of: .value) { (snapshot) in
            if let name = snapshot.value as? [String: AnyObject] {
                self.topNameLabel.text = name["username"] as? String
            }
        }
    }
}
