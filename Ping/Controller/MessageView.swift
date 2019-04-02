//
//  MessageView.swift
//  Ping
//
//  Created by Ryan Soanes on 15/02/2019.
//  Copyright © 2019 LionStone. All rights reserved.
//

import UIKit
import Firebase

class MessageView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var messageTextInput: UITextField!
    @IBOutlet var messageNameLabel: UILabel!
    @IBOutlet var messageTableView: UITableView!
    var messages = [MessageData]() //declared array to hold messages
    var username: String!
    var currentUser: UserStored?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        messageTableView.delegate = self //sets self as delegate for table view
        messageTableView.dataSource = self //sets self as data source for table view
        messageTableView.register(UINib(nibName: "CustomMessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell") //register xib file to chat table view
        configureTableView()
        hideKeyboardWhenTappedAround()
        messageNameLabel.text = currentUser?.username
        refreshMessages()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell //initiate custom cell for chat table view
        cell.messageFromUserText.text = messages[indexPath.row].text //alter chatUsername element with test data for username
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //returns number of cells wanted on tableview
        return messages.count
    }
    
    func configureTableView() {
        messageTableView.rowHeight = UITableView.automaticDimension //adjust the height of the cell to content
        messageTableView.estimatedRowHeight = 35.0
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendMessageButton(_ sender: UIButton) {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId() //adds a child node to ref with a unique id for each message
        let timestamp = NSNumber(value: NSDate().timeIntervalSince1970)
        let values = ["text": messageTextInput.text!, "recipient": currentUser?.uid, "sender": Auth.auth().currentUser?.uid, "timestamp": timestamp] as [String : Any]
        childRef.updateChildValues(values as [AnyHashable : Any])
        print(messageTextInput.text!)
    }
    
    func refreshMessages() {
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = MessageData()
                message.setValuesForKeys(dictionary)
                self.messages.append(message)
                DispatchQueue.main.async(execute: {
                    self.messageTableView.reloadData()
                })
            }
        }, withCancel: nil)
    }
    
//    func retrieveUsername() {
//        let loggedUser = Auth.auth().currentUser
//        var databaseReference: DatabaseReference!
//        databaseReference = Database.database().reference()
//        databaseReference.child("users").child((loggedUser?.uid)!).observeSingleEvent(of: .value) { (snapshot) in
//            if let name = snapshot.value as? [String: AnyObject] {
//                self.messageNameLabel.text = name["username"] as? String
//                self.username = name["username"] as? String
//            }
//        }
//    }
}

